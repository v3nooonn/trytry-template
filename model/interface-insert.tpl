Columns(ctx context.Context) squirrel.SelectBuilder
TransCtx(ctx context.Context, fn func(context.Context, sqlx.Session) error) error

Insert(ctx context.Context, data *{{.upperStartCamelObject}}) (int64, error)
TransInsert(ctx context.Context, session sqlx.Session, data *{{.upperStartCamelObject}}) (int64, error)