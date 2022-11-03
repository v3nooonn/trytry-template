
func (m *default{{.upperStartCamelObject}}Model) Insert(ctx context.Context, data *{{.upperStartCamelObject}}) (sql.Result,error) {
	if err := schema.Set(ctx, m.CachedConn); err != nil {
    	return nil, errors.Wrap(err, "failed to set pg schema")
    }
    data.SetCreatedAtAndUpdatedAt()

	{{if .withCache}}{{.keys}}
	{{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    ret, err := m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("insert into %s (%s) values ({{.expression}})", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
		return conn.ExecCtx(ctx, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("insert into %s (%s) values ({{.expression}})", m.table, {{.lowerStartCamelObject}}RowsExpectAutoSet)
    ret,err:=m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}

	return ret, errors.Wrap(err, "failed to insert {{.upperStartCamelObject}}")
}
