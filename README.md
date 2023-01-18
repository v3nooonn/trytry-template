# trytry-template
Templates modifications based on the default from goctl, which includes:
- Postgresql adaptations, mainly means schema switchover and moving index query to custom model.
- Schema injection in cache key
- Transaction
- Renaming

For goctl:
- Keep primary key only in `_gen` model
