CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(65535) NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


INSERT INTO
users (fname, lname)
VALUES
('Bobby', 'Tables'), ('Chris', 'Boaks'), ('Matt', 'Kevins');

INSERT INTO
questions (title, body, author_id)
VALUES
('How do I ruby?', 'Seriously i do not get it', (SELECT id FROM users WHERE fname = 'Chris')),
('What is the answer to this question?', 'See above', (SELECT id FROM users WHERE fname = 'Matt')),
('Fuckin magnets, how do they work?', 'Its crazy', (SELECT id FROM users WHERE fname = 'Chris'));

INSERT INTO
question_followers (user_id, question_id)
VALUES
((SELECT id FROM users WHERE fname = 'Chris'), (SELECT id FROM questions WHERE title LIKE 'Fuckin%')),
((SELECT id FROM users WHERE fname = 'Bobby'), (SELECT id FROM questions WHERE title LIKE 'Fuckin%')),
((SELECT id FROM users WHERE fname = 'Matt'), (SELECT id FROM questions WHERE title LIKE 'Fuckin%')),
((SELECT id FROM users WHERE fname = 'Chris'), (SELECT id FROM questions WHERE title LIKE 'What%'));

