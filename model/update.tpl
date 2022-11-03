
func (m *default{{.upperStartCamelObject}}Model) Update(ctx context.Context, {{if .containsIndexCache}}newData{{else}}data{{end}} *{{.upperStartCamelObject}}) error {
    if err := schema.Set(ctx, m.CachedConn); err != nil {
    	return errors.Wrap(err, "failed to set pg schema")
    }
    {{if .containsIndexCache}}newData.SetUpdatedAt(){{else}}data.SetUpdatedAt(){{end}}

	{{if .withCache}}{{if .containsIndexCache}}data, err:=m.FindOne(ctx, newData.{{.upperStartCamelPrimaryKey}})
	if err!=nil{
		return errors.Wrap(err, "failed to find {{.upperStartCamelObject}}")
	}

{{end}}	{{.keys}}
    {{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    _, {{if .containsIndexCache}}err{{else}}err:{{end}}= m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.table, {{.lowerStartCamelObject}}RowsWithPlaceHolder)
		return conn.ExecCtx(ctx, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.table, {{.lowerStartCamelObject}}RowsWithPlaceHolder)
    _,err:=m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}

	return errors.Wrap(err, "failed to update {{.upperStartCamelObject}}")
}
