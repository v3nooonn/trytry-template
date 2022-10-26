
func new{{.upperStartCamelObject}}(conn sqlx.SqlConn{{if .withCache}}, c cache.CacheConf{{end}}) *default{{.upperStartCamelObject}}Model {
	return &basic{
		{{if .withCache}}CachedConn: sqlc.NewConn(conn, c){{else}}conn:conn{{end}},
		table:      {{.table}},
	}
}
{{if .withCache}}func (m *basic) genCacheKey(ctx context.Context) string {
	tnt := ctx.Value(constant.Tenant).(string)
	return fmt.Sprintf({{.cacheKeys}}, tnt)
}{{end}}