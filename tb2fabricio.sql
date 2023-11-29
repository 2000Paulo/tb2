CREATE database redes_sociais;
USE redes_sociais;

CREATE TABLE Usuarios (
    UserID INT PRIMARY KEY,
    Nome VARCHAR(50)
);

CREATE TABLE Postagens (
    PostID INT PRIMARY KEY,
    UserID INT,
    Texto VARCHAR(255),
    DataPublicacao DATE,
    FOREIGN KEY (UserID) REFERENCES Usuarios(UserID)
);

CREATE TABLE Comentarios (
    ComentarioID INT PRIMARY KEY,
    PostID INT,
    UserID INT,
    Texto VARCHAR(255),
    DataComentario DATE,
    FOREIGN KEY (PostID) REFERENCES Postagens(PostID),
    FOREIGN KEY (UserID) REFERENCES Usuarios(UserID)
);

CREATE TABLE Amizades (
    AmizadeID INT PRIMARY KEY,
    UserID1 INT,
    UserID2 INT,
    DataAmizade DATE,
    FOREIGN KEY (UserID1) REFERENCES Usuarios(UserID),
    FOREIGN KEY (UserID2) REFERENCES Usuarios(UserID)
);

INSERT INTO Usuarios (UserID, Nome) VALUES
(1, 'João'),
(2, 'Maria'),
(3, 'Paulo'),
(4, 'Victor');

INSERT INTO Postagens (PostID, UserID, Texto, DataPublicacao) VALUES
(101, 1, 'Comprei um Carro!', '2022-11-09'),
(102, 2, 'Fala Galera!', '2022-12-15'),
(103, 3, 'Qual a boa para hoje?', '2023-03-20'),
(104, 1, 'Bom dia a Todos', '2023-04-05');

INSERT INTO Comentarios (ComentarioID, PostID, UserID, Texto, DataComentario) VALUES
(201, 101, 2, 'Legal João, parabéns!', '2022-11-09'),
(202, 102, 1, 'Falae Maria!', '2022-12-15'),
(203, 103, 4, 'Com esse sol vai dar praia.', '2023-03-25'),
(204, 101, 3, 'Bom dia!', '2023-04-06');

INSERT INTO Amizades (AmizadeID, UserID1, UserID2, DataAmizade) VALUES
(301, 1, 2, '2022-01-15'),
(302, 3, 4, '2022-03-01'),
(303, 2, 4, '2022-04-10');

SELECT * FROM Postagens WHERE UserID = (SELECT UserID FROM Usuarios WHERE Nome = 'João');
SELECT * FROM Comentarios WHERE PostID = (SELECT PostID FROM Postagens WHERE Texto = 'Bom dia, mundo!');

SELECT 
    u.UserID,
    u.Nome,
    COUNT(DISTINCT p.PostID) AS TotalPostagens,
    COUNT(DISTINCT c.ComentarioID) AS TotalComentarios
FROM Usuarios u
LEFT JOIN Postagens p ON u.UserID = p.UserID
LEFT JOIN Comentarios c ON u.UserID = c.UserID
GROUP BY u.UserID, u.Nome;

SELECT * FROM Amizades
WHERE DataAmizade >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

SELECT 
    u.Nome,
    p.Texto AS Postagem,
    a2.Nome AS NomeAmigo
FROM Usuarios u
LEFT JOIN Postagens p ON u.UserID = p.UserID
LEFT JOIN Amizades a ON u.UserID = a.UserID1 OR u.UserID = a.UserID2
LEFT JOIN Usuarios a2 ON (a.UserID1 = u.UserID AND a.UserID2 = a2.UserID) OR (a.UserID2 = u.UserID AND a.UserID1 = a2.UserID)
WHERE u.Nome = 'Maria';
