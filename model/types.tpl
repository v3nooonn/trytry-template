
type (
	{{.lowerStartCamelObject}}Basic interface{
		{{.method}}
	}

	basic struct {
		{{if .withCache}}sqlc.CachedConn{{else}}conn sqlx.SqlConn{{end}}
		table string
	}

	{{.upperStartCamelObject}} struct {
		{{.fields}}
	}
)
