DROP TABLE IF EXISTS worker;
CREATE TABLE worker (
    id   SMALLINT not null auto_increment primary key,
    name VARCHAR(50) not null,
    bossname VARCHAR(50)
);
INSERT INTO worker (name, bossname) values ('juan', 'ramon');
INSERT INTO worker (name, bossname) values ('luis', 'ramon');
INSERT INTO worker (name, bossname) values ('diego', 'luis');
INSERT INTO worker (name, bossname) values ('ramon', null);

