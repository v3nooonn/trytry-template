
func (m *default{{.upperStartCamelObject}}Model) Delete(ctx context.Context, {{.lowerStartCamelPrimaryKey}} {{.dataType}}) error {
	{{if .withCache}}{{if .containsIndexCache}}data, err:=m.FindOne(ctx, {{.lowerStartCamelPrimaryKey}})
	if err!=nil{
		return errors.Wrap(err, "failed to find {{.upperStartCamelObject}}")
	}

    {{end}}{{.keys}}
    {{.keyValues}} = cachekey.Set(ctx, {{.keyValues}})
    _, err {{if .containsIndexCache}}={{else}}:={{end}} m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("delete from %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.tableName(ctxutil.GetTenant(ctx)))
		return conn.ExecCtx(ctx, query, {{.lowerStartCamelPrimaryKey}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("delete from %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.tableName(ctxutil.GetTenant(ctx)))
		_, err := m.conn.ExecCtx(ctx, query, {{.lowerStartCamelPrimaryKey}}){{end}}

	return errors.Wrap(err, "failed to delete {{.upperStartCamelObject}}")
}
