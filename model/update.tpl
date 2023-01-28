
func (m *default{{.upperStartCamelObject}}Model) Update(ctx context.Context, {{if .containsIndexCache}}newData{{else}}data{{end}} *{{.upperStartCamelObject}}) error {
    schema := ctxutil.GetTenant(ctx)

    {{if .containsIndexCache}}newData.SetUpdatedAt(){{else}}data.SetUpdatedAt(){{end}}

	{{if .withCache}}{{if .containsIndexCache}}data, err:=m.FindOne(ctx, newData.{{.upperStartCamelPrimaryKey}})
	if err!=nil{
		return errors.Wrap(err, "failed to find {{.upperStartCamelObject}}")
	}

    {{end}}{{.keys}}
    {{range .keysList}}
    {{.}} = cachekey.SchInit({{.}}, ctxutil.GetTenant(ctx)){{end}}

    _, {{if .containsIndexCache}}err{{else}}err:{{end}}= m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.tableName(schema), {{.lowerStartCamelObject}}RowsWithPlaceHolder)

		return conn.ExecCtx(ctx, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.tableName(schema), {{.lowerStartCamelObject}}RowsWithPlaceHolder)
    _, err := m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}

	return errors.Wrap(err, "failed to update {{.upperStartCamelObject}}")
}

func (m *default{{.upperStartCamelObject}}Model) TransUpdate(ctx context.Context, session sqlx.Session, {{if .containsIndexCache}}newData{{else}}data{{end}} *{{.upperStartCamelObject}}) error {
    schema := ctxutil.GetTenant(ctx)

    {{if .containsIndexCache}}newData.SetUpdatedAt(){{else}}data.SetUpdatedAt(){{end}}

	{{if .withCache}}{{if .containsIndexCache}}data, err:=m.FindOne(ctx, newData.{{.upperStartCamelPrimaryKey}})
	if err!=nil{
		return errors.Wrap(err, "failed to find {{.upperStartCamelObject}}")
	}

    {{end}}{{.keys}}
    {{range .keysList}}
    {{.}} = cachekey.SchInit({{.}}, ctxutil.GetTenant(ctx)){{end}}

    _, {{if .containsIndexCache}}err{{else}}err:{{end}}= m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (result sql.Result, err error) {
		query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.tableName(schema), {{.lowerStartCamelObject}}RowsWithPlaceHolder)

		return session.ExecCtx(ctx, query, {{.expressionValues}})
	}, {{.keyValues}}){{else}}query := fmt.Sprintf("update %s set %s where {{.originalPrimaryKey}} = {{if .postgreSql}}$1{{else}}?{{end}}", m.tableName(schema), {{.lowerStartCamelObject}}RowsWithPlaceHolder)
    _, err := m.conn.ExecCtx(ctx, query, {{.expressionValues}}){{end}}

	return errors.Wrap(err, "failed to update {{.upperStartCamelObject}}")
}