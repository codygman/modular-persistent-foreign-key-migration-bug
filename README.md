# persistent-modular-foreign-key-bug

## Things work fine in the same file (initial commit)

```shell
~/org-roam/daily/data/63/787637-e72b-426f-888d-72b3280d33e9/persistent-modular-foreign-key-bug $ stack run
Migrating: CREATE TABLE "person"("id" INTEGER PRIMARY KEY,"name" VARCHAR NOT NULL,"age" INTEGER NULL)
Migrating: CREATE TABLE "blog_post"("id" INTEGER PRIMARY KEY,"title" VARCHAR NOT NULL,"author_id" INTEGER NOT NULL REFERENCES "person" ON DELETE RESTRICT ON UPDATE RESTRICT)
[Entity {entityKey = BlogPostKey {unBlogPostKey = SqlBackendKey {unSqlBackendKey = 1}}, entityVal = BlogPost {blogPostTitle = "My fr1st p0st", blogPostAuthorId = PersonKey {unPersonKey = SqlBackendKey {unSqlBackendKey = 1}}}}]
Just (Person {personName = "John Doe", personAge = Just 35})
```
