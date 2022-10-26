package {{.pkg}}
{{if .withCache}}
import (
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)
{{else}}
import "github.com/zeromicro/go-zero/core/stores/sqlx"
{{end}}
var _ {{.upperStartCamelObject}}Model = (*custom{{.upperStartCamelObject}}Model)(nil)

type (
	{{.upperStartCamelObject}}Model interface {
		{{.lowerStartCamelObject}}Default
	}

	{{.upperStartCamelObject}} struct {
		*{{.upperStartCamelObject}}Default
	}
)

func New{{.upperStartCamelObject}}(conn sqlx.SqlConn{{if .withCache}}, c cache.CacheConf{{end}}) {{.upperStartCamelObject}}Model {
	return &custom{{.upperStartCamelObject}}Default{
		{{.upperStartCamelObject}}Default: new{{.upperStartCamelObject}}Default(conn{{if .withCache}}, c{{end}}),
	}
}
