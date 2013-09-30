CREATE TABLE event (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT,
    location     TEXT,
    owner        INTEGER,
    begin_time   INTEGER,
    end_time     INTEGER,
    member_limit INTEGER,
    hashtag      INTEGER,
    description  TEXT,
    created_at   INTEGER,
    updated_at   INTEGER
);

CREATE TABLE member (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT,
    created_at INTEGER,
    updated_at INTEGER
);

CREATE TABLE member_service (
    member_id          INTEGER,
    service            TEXT,
    account_on_service TEXT,
    created_at         INTEGER,
    updated_at         INTEGER
);

CREATE TABLE event_member (
    event_id    INTEGER,
    member_id   INTEGER,
    created_at  INTEGER,
    canceled_at INTEGER,
);

