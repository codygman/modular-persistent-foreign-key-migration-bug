# persistent-modular-foreign-key-bug

## Doing migrations for multiple external files correctly

https://www.parsonsmatt.org/2019/12/06/splitting_persistent_models.html#migrations

Still has the same error with no such table person:

```
~/org-roam/daily/data/63/787637-e72b-426f-888d-72b3280d33e9/persistent-modular-foreign-key-bug $ stack run
persistent-modular-foreign-key-bug: SQLite3 returned ErrorError while attempting to perform prepare "INSERT INTO \"person\"(\"name\",\"age\") VALUES(?,?)": no such table: person
```

## External persistentmodel file, using $(discoverEntities)

```
~/org-roam/daily/data/63/787637-e72b-426f-888d-72b3280d33e9/persistent-modular-foreign-key-bug $ stack run
persistent-modular-foreign-key-bug> configure (exe)
Configuring persistent-modular-foreign-key-bug-0.1.0.0...
persistent-modular-foreign-key-bug> build (exe)
Preprocessing executable 'persistent-modular-foreign-key-bug' for persistent-modular-foreign-key-bug-0.1.0.0..
Building executable 'persistent-modular-foreign-key-bug' for persistent-modular-foreign-key-bug-0.1.0.0..
[2 of 2] Compiling Main
Linking .stack-work/dist/x86_64-linux-nix/Cabal-3.2.1.0/build/persistent-modular-foreign-key-bug/persistent-modular-foreign-key-bug ...
/nix/store/fh9f7pr9kxfwvs8lm4479lvhrkzmmkdw-binutils-2.35.1/bin/ld.gold: warning: /nix/store/j5p0j1w27aqdzncpw73k95byvhh5prw2-glibc-2.33-47/lib/crt1.o: unknown program property type 0xc0008002 in .note.gnu.property section
persistent-modular-foreign-key-bug> copy/register
Installing executable persistent-modular-foreign-key-bug in /home/cody/org-roam/daily/data/63/787637-e72b-426f-888d-72b3280d33e9/persistent-modular-foreign-key-bug/.stack-work/install/x86_64-linux-nix/dbc3a4b52a40f5f688d604f7d4be311788ef89d4d5750fd530bb0d7a43f48d94/8.10.4/bin
Migrating: CREATE TABLE "person"("id" INTEGER PRIMARY KEY,"name" VARCHAR NOT NULL,"age" INTEGER NULL)
persistent-modular-foreign-key-bug: Table not found: Person
CallStack (from HasCallStack):
  error, called at ./Database/Persist/Sql/Internal.hs:201:40 in persistent-2.13.1.1-JiRW3gwovv46KSlCldCWsH:Database.Persist.Sql.Internal
```

## No foreign key reference after factoring out Person

Notice in the migration output below how there's no longer a `REFERENCES "person"`

```shell
~/org-roam/daily/data/63/787637-e72b-426f-888d-72b3280d33e9/persistent-modular-foreign-key-bug $ stack run
persistent-modular-foreign-key-bug> configure (exe)
Configuring persistent-modular-foreign-key-bug-0.1.0.0...
persistent-modular-foreign-key-bug> build (exe)
Preprocessing executable 'persistent-modular-foreign-key-bug' for persistent-modular-foreign-key-bug-0.1.0.0..
Building executable 'persistent-modular-foreign-key-bug' for persistent-modular-foreign-key-bug-0.1.0.0..
persistent-modular-foreign-key-bug> copy/register
Installing executable persistent-modular-foreign-key-bug in /home/cody/org-roam/daily/data/63/787637-e72b-426f-888d-72b3280d33e9/persistent-modular-foreign-key-bug/.stack-work/install/x86_64-linux-nix/dbc3a4b52a40f5f688d604f7d4be311788ef89d4d5750fd530bb0d7a43f48d94/8.10.4/bin
Migrating: CREATE TABLE "person"("id" INTEGER PRIMARY KEY,"name" VARCHAR NOT NULL,"age" INTEGER NULL)
Migrating: CREATE TABLE "blog_post"("id" INTEGER PRIMARY KEY,"title" VARCHAR NOT NULL,"author_id" INTEGER NOT NULL)
[Entity {entityKey = BlogPostKey {unBlogPostKey = SqlBackendKey {unSqlBackendKey = 1}}, entityVal = BlogPost {blogPostTitle = "My fr1st p0st", blogPostAuthorId = PersonKey {unPersonKey = SqlBackendKey {unSqlBackendKey = 1}}}}]
Just (Person {personName = "John Doe", personAge = Just 35})
```

## Things work fine in the same file (initial commit)

```shell
~/org-roam/daily/data/63/787637-e72b-426f-888d-72b3280d33e9/persistent-modular-foreign-key-bug $ stack run
Migrating: CREATE TABLE "person"("id" INTEGER PRIMARY KEY,"name" VARCHAR NOT NULL,"age" INTEGER NULL)
Migrating: CREATE TABLE "blog_post"("id" INTEGER PRIMARY KEY,"title" VARCHAR NOT NULL,"author_id" INTEGER NOT NULL REFERENCES "person" ON DELETE RESTRICT ON UPDATE RESTRICT)
[Entity {entityKey = BlogPostKey {unBlogPostKey = SqlBackendKey {unSqlBackendKey = 1}}, entityVal = BlogPost {blogPostTitle = "My fr1st p0st", blogPostAuthorId = PersonKey {unPersonKey = SqlBackendKey {unSqlBackendKey = 1}}}}]
Just (Person {personName = "John Doe", personAge = Just 35})
```
