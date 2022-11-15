
func (m *default{{.upperStartCamelObject}}Model) Insert(ctx context.Context, data *{{.upperStartCamelObject}}) (int64, error) {
	var id int64 = 0

	if err := schema.Set(ctx, m.CachedConn); err != nil {
    	return id, errors.Wrap(err, "failed to set pg schema")
    }
    data.SetCreatedAtAndUpdatedAt()

	{{if .withCache}}{{.keys}}
	{{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}})", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
		err = conn.QueryRowCtx(ctx, &id, query, {{.expressionValues}})

		return nil, err
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURING id", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
    _, err:=m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}


	return id, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
}

func (m *default{{.upperStartCamelObject}}Model) TransInsert(ctx context.Context, session sqlx.Session, data *{{.upperStartCamelObject}}) (int64, error) {
	var id int64 = 0
    data.SetCreatedAtAndUpdatedAt()

	{{if .withCache}}{{.keys}}
	{{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}})", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
		err = session.QueryRowCtx(ctx, &id, query, {{.expressionValues}})

		return nil, err
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURING id", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
    _, err:=m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}


	return id, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
}

func (m *default{{.upperStartCamelObject}}Model) TransCtx(ctx context.Context, fn func(context.Context, sqlx.Session) error) error {
	if err := schema.Set(ctx, m.CachedConn); err != nil {
    	return errors.Wrap(err, "failed to set pg schema")
    }

	return m.CachedConn.TransactCtx(ctx, func(ctx context.Context, session sqlx.Session) error {
          return fn(ctx, session)
    })
}
