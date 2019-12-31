USE sample;

CREATE TABLE hello(
    id int not null auto_increment primary key,
    lang text
);

INSERT INTO sample.hello (lang) VALUES ("Golang");
INSERT INTO sample.hello (lang) VALUES ("SQL");
INSERT INTO sample.hello (lang) VALUES ("PHP");
INSERT INTO sample.hello (lang) VALUES ("Java");
INSERT INTO sample.hello (lang) VALUES ("C");
