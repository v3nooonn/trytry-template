
func (m *default{{.upperStartCamelObject}}Model) Columns(ctx context.Context) squirrel.SelectBuilder {
	return squirrel.Select({{.lowerStartCamelObject}}Rows).From(m.tableName(ctxutil.GetTenant(ctx))).PlaceholderFormat(squirrel.Dollar)
}

func (m *default{{.upperStartCamelObject}}Model) TransCtx(ctx context.Context, fn func(context.Context, sqlx.Session) error) error {
    return m.CachedConn.TransactCtx(
		ctx,
		func(ctx context.Context, session sqlx.Session) error {
			return fn(ctx, session)
		},
	)
}

func (m *default{{.upperStartCamelObject}}Model) Insert(ctx context.Context, data *{{.upperStartCamelObject}}) (int64, error) {
	schema := ctxutil.GetTenant(ctx)

	var id int64 = 0
    data.SetCreatedAtAndUpdatedAt()

	{{if .withCache}}{{.keys}}
    {{range .keysList}}
    {{.}} = cachekey.SchInit({{.}}, ctxutil.GetTenant(ctx)){{end}}

    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(schema), {{.lowerStartCamelObject}}RowsExpectAutoSet)

		return nil, conn.QueryRowCtx(ctx, &id, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(schema), {{.lowerStartCamelObject}}RowsExpectAutoSet)
    _, err := m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}

	return id, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
}

func (m *default{{.upperStartCamelObject}}Model) TransInsert(ctx context.Context, session sqlx.Session, data *{{.upperStartCamelObject}}) (int64, error) {
	schema := ctxutil.GetTenant(ctx)

	var id int64 = 0
    data.SetCreatedAtAndUpdatedAt()

	{{if .withCache}}{{.keys}}
    {{range .keysList}}
    {{.}} = cachekey.SchInit({{.}}, ctxutil.GetTenant(ctx)){{end}}

    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(schema), {{.lowerStartCamelObject}}RowsExpectAutoSet)

		return nil, session.QueryRowCtx(ctx, &id, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURNING id", m.tableName(schema), {{.lowerStartCamelObject}}RowsExpectAutoSet)
    _, err:=m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}

    return id, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
}
