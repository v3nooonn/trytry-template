
func (m *default{{.upperStartCamelObject}}Model) Columns(ctx context.Context) squirrel.SelectBuilder {
	return squirrel.Select(authenticationRows).From(m.tableName(ctxutil.GetTenant(ctx))).PlaceholderFormat(squirrel.Dollar)
}

func (m *default{{.upperStartCamelObject}}Model) TransCtx(ctx context.Context, fn func(context.Context, sqlx.Session) error) error {
	return m.CachedConn.TransactCtx(ctx, func(ctx context.Context, session sqlx.Session) error {
          return fn(ctx, session)
    })
}

func (m *default{{.upperStartCamelObject}}Model) Insert(ctx context.Context, data *{{.upperStartCamelObject}}) (int64, error) {
	var id int64 = 0
    data.SetCreatedAtAndUpdatedAt()

	{{if .withCache}}{{.keys}}
	{{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(ctxutil.GetTenant(ctx)), {{.lowerStartCamelObject}}RowsExpectAutoSet)
		return nil, conn.QueryRowCtx(ctx, &id, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(ctxutil.GetTenant(ctx)), {{.lowerStartCamelObject}}RowsExpectAutoSet)
    _, err := m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}
    if err != nil {
    	return id, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
    }

	return id, nil
}

func (m *default{{.upperStartCamelObject}}Model) TransInsert(ctx context.Context, session sqlx.Session, data *{{.upperStartCamelObject}}) (int64, error) {
	var id int64 = 0
    data.SetCreatedAtAndUpdatedAt()

	{{if .withCache}}{{.keys}}
	{{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(ctxutil.GetTenant(ctx)), {{.lowerStartCamelObject}}RowsExpectAutoSet)
		err = session.QueryRowCtx(ctx, &id, query, {{.expressionValues}})

		return nil, err
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(ctxutil.GetTenant(ctx)), {{.lowerStartCamelObject}}RowsExpectAutoSet)
    _, err:=m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}
    if err != nil {
    	return id, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
    }

	return id, nil
}
