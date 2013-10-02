CREATE TABLE event (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT NOT NULL,
    location     TEXT,
    owner        INTEGER NOT NULL,
    begin_time   INTEGER NOT NULL,
    end_time     INTEGER NOT NULL,
    member_limit INTEGER DEFAULT 1,
    hashtag      INTEGER,
    description  TEXT,
    created_at   INTEGER,
    updated_at   INTEGER,
    UNIQUE(name)
);

CREATE TABLE member (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    name       TEXT NOT NULL,
    created_at INTEGER,
    updated_at INTEGER,
    UNIQUE(name)
);

CREATE TABLE member_service (
    member_id          INTEGER NOT NULL,
    service            TEXT NOT NULL,
    account_on_service TEXT NOT NULL,
    created_at         INTEGER,
    updated_at         INTEGER,
    PRIMARY KEY(member_id, service, account_on_service)
);

CREATE TABLE event_member (
    event_id    INTEGER NOT NULL,
    member_id   INTEGER NOT NULL,
    created_at  INTEGER,
    canceled_at INTEGER,
    PRIMARY KEY(event_id, member_id)
);

