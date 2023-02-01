# trytry-template
Templates modifications based on the default from goctl, which includes:
- Postgresql adaptations, mainly means schema switchover and changing index query.
- Schema injection in cache key
- Transaction
- Renaming

For goctl:
- Keep primary key only in `_gen` model
- Add more keys in map to updating the cache keys of other constraints in table.
