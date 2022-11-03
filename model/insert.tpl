
func (m *default{{.upperStartCamelObject}}Model) Insert(ctx context.Context, data *{{.upperStartCamelObject}}) (int64, error) {
	if err := schema.Set(ctx, m.CachedConn); err != nil {
    	return nil, errors.Wrap(err, "failed to set pg schema")
    }
    data.SetCreatedAtAndUpdatedAt()

	var id int64
	{{if .withCache}}{{.keys}}
	{{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    _, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}})", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
		return conn.QueryRowCtx(ctx, &id, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}}) RETURING id", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
    ret,err:=m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}

	return id, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
}
