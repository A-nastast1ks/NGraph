USE MASTER
GO
DROP DATABASE IF EXISTS NGraph
GO
CREATE DATABASE NGraph
GO
USE NGraph
GO

-- �������� ������ �����
CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Affiliation NVARCHAR(100),
    Email NVARCHAR(100)
) AS NODE;

CREATE TABLE Articles (
    ArticleID INT PRIMARY KEY,
    Title NVARCHAR(200),
    YearPublished INT,
    DOI NVARCHAR(100),
    CitationCount INT DEFAULT 0
) AS NODE;

CREATE TABLE ResearchTopics (
    TopicID INT PRIMARY KEY,
    TopicName NVARCHAR(100),
    Description NVARCHAR(500)
) AS NODE;

-- �������� ������ �����
CREATE TABLE Wrote (
    ContributionType NVARCHAR(50) -- 'MainAuthor', 'CoAuthor'
) AS EDGE;

CREATE TABLE Cited (
    CitationContext NVARCHAR(200),
    CitationDate DATE
) AS EDGE;

CREATE TABLE RelatedTo (
    RelevanceScore INT -- �� 1 �� 10
) AS EDGE;

INSERT INTO Authors (AuthorID, Name, Affiliation, Email) VALUES
(1, '������ �.�.', '���', 'ivanov@msu.ru'),
(2, '������� �.�.', '�����', 'petrova@spbu.ru'),
(3, '������� �.�.', '���', 'sidorov@nsu.ru'),
(4, '��������� �.�.', '����', 'kuznetsova@mipt.ru'),
(5, '������� �.�.', '���', 'smirnov@hse.ru'),
(6, '�������� �.�.', '����', 'vasiliev@bmstu.ru'),
(7, '��������� �.�.', '����', 'nikolaeva@itmo.ru'),
(8, '������� �.�.', '���', 'lebedev@msu.ru'),
(9, '�������� �.�.', '�����', 'sokolova@spbu.ru'),
(10, '������ �.�.', '���', 'pavlov@nsu.ru');

INSERT INTO Articles (ArticleID, Title, YearPublished, DOI, CitationCount) VALUES
(1, '������������ ������ ������� ������', 20, '10.1234/nsa', 45),
(2, '��������� ����������: ����� �������', 21, '10.1234/qc', 32),
(3, '�������������� � �������� ��������', 19, '10.1234/bio', 28),
(4, '����������� ���������� ������', 22, '10.1234/opt', 15),
(5, '���������� ��������� � �����', 20, '10.1234/block', 40),
(6, '�������� �������� ��� ����������� �����������', 21, '10.1234/dlmed', 37),
(7, '����� ��������� � ���������������', 18, '10.1234/nano', 52),
(8, '������ ������������� ������', 22, '10.1234/cv', 23),
(9, '����������������� ��������� ��������', 21, '10.1234/crypto', 19),
(10, '������������ ��������� �����������', 20, '10.1234/evo', 31);

INSERT INTO ResearchTopics (TopicID, TopicName, Description) VALUES
(1, '������������� ���������', '������ ��������� �������� � ��'),
(2, '��������� ����������', '��������� ��������� � ����������'),
(3, '��������������', '������ ������������� ������'),
(4, '������������', '������ ���������� � ����������'),
(5, '��������������', '��������� � ���������� �����������'),
(6, '������������ ������', '������ � ��������� �����������'),
(7, '������� ������', '��������� � ������ ������� ��������'),
(8, '�������������� �������', '����������� �������������� ����������'),
(9, '��������� ������', '������ NLP � ��������� ���������'),
(10, '����������� �����������', '�� � ���������������');

INSERT INTO Wrote ($from_id, $to_id, ContributionType) VALUES
-- ������ �.�. (������ 1, 5, 10)
((SELECT $node_id FROM Authors WHERE AuthorID = 1), (SELECT $node_id FROM Articles WHERE ArticleID = 1), 'MainAuthor'),
((SELECT $node_id FROM Authors WHERE AuthorID = 1), (SELECT $node_id FROM Articles WHERE ArticleID = 5), 'CoAuthor'),
((SELECT $node_id FROM Authors WHERE AuthorID = 1), (SELECT $node_id FROM Articles WHERE ArticleID = 10), 'CoAuthor'),

-- ������� �.�. (������ 2, 6)
((SELECT $node_id FROM Authors WHERE AuthorID = 2), (SELECT $node_id FROM Articles WHERE ArticleID = 2), 'MainAuthor'),
((SELECT $node_id FROM Authors WHERE AuthorID = 2), (SELECT $node_id FROM Articles WHERE ArticleID = 6), 'CoAuthor'),

-- ������� �.�. (������ 3, 7, 10)
((SELECT $node_id FROM Authors WHERE AuthorID = 3), (SELECT $node_id FROM Articles WHERE ArticleID = 3), 'MainAuthor'),
((SELECT $node_id FROM Authors WHERE AuthorID = 3), (SELECT $node_id FROM Articles WHERE ArticleID = 7), 'CoAuthor'),
((SELECT $node_id FROM Authors WHERE AuthorID = 3), (SELECT $node_id FROM Articles WHERE ArticleID = 10), 'CoAuthor'),

-- ��������� �.�. (������ 4, 8, 10)
((SELECT $node_id FROM Authors WHERE AuthorID = 4), (SELECT $node_id FROM Articles WHERE ArticleID = 4), 'MainAuthor'),
((SELECT $node_id FROM Authors WHERE AuthorID = 4), (SELECT $node_id FROM Articles WHERE ArticleID = 10), 'MainAuthor'),
((SELECT $node_id FROM Authors WHERE AuthorID = 4), (SELECT $node_id FROM Articles WHERE ArticleID = 8), 'CoAuthor');


-- ������ 1 �������� 3 � 7
INSERT INTO Cited ($from_id, $to_id, CitationContext, CitationDate) VALUES
((SELECT $node_id FROM Articles WHERE ArticleID = 1), (SELECT $node_id FROM Articles WHERE ArticleID = 3), '������ ��������������', '20-05-15'),
((SELECT $node_id FROM Articles WHERE ArticleID = 1), (SELECT $node_id FROM Articles WHERE ArticleID = 7), '���������� ��������������', '20-05-15'),


-- ������ 2 �������� 10
((SELECT $node_id FROM Articles WHERE ArticleID = 2), (SELECT $node_id FROM Articles WHERE ArticleID = 10), '������������ ���������', '21-02-20'),

-- ������ 3 �������� 10
((SELECT $node_id FROM Articles WHERE ArticleID = 3), (SELECT $node_id FROM Articles WHERE ArticleID = 10), '������ ������ � ������', '19-11-10'),

-- ������ 5 �������� 1 � 4
((SELECT $node_id FROM Articles WHERE ArticleID = 5), (SELECT $node_id FROM Articles WHERE ArticleID = 1), '������������ ������', '20-08-30'),
((SELECT $node_id FROM Articles WHERE ArticleID = 5), (SELECT $node_id FROM Articles WHERE ArticleID = 4), '����������� ����������', '20-08-30'),

-- ������ 6 �������� 3 � 1
((SELECT $node_id FROM Articles WHERE ArticleID = 6), (SELECT $node_id FROM Articles WHERE ArticleID = 3), '������������������ �������', '21-04-12'),
((SELECT $node_id FROM Articles WHERE ArticleID = 6), (SELECT $node_id FROM Articles WHERE ArticleID = 1), '��������� ���������', '21-04-12'),

-- ������ 10 �������� 6
((SELECT $node_id FROM Articles WHERE ArticleID = 10), (SELECT $node_id FROM Articles WHERE ArticleID = 6), '������ ������ � ����� ����������� �����������', '19-11-10');

-- ������ 1 ��������� � �� � ��������� ������
INSERT INTO RelatedTo ($from_id, $to_id, RelevanceScore) VALUES
((SELECT $node_id FROM Articles WHERE ArticleID = 1), (SELECT $node_id FROM ResearchTopics WHERE TopicID = 1), 9),
((SELECT $node_id FROM Articles WHERE ArticleID = 1), (SELECT $node_id FROM ResearchTopics WHERE TopicID = 9), 8),

-- ������ 2 ��������� � ��������� �����������
((SELECT $node_id FROM Articles WHERE ArticleID = 2), (SELECT $node_id FROM ResearchTopics WHERE TopicID = 2), 10),

-- ������ 3 ��������� � �������������� � ��
((SELECT $node_id FROM Articles WHERE ArticleID = 3), (SELECT $node_id FROM ResearchTopics WHERE TopicID = 3), 10),
((SELECT $node_id FROM Articles WHERE ArticleID = 3), (SELECT $node_id FROM ResearchTopics WHERE TopicID = 1), 7),

-- ������ 5 ��������� � ������������ � �������������� ��������
((SELECT $node_id FROM Articles WHERE ArticleID = 5), (SELECT $node_id FROM ResearchTopics WHERE TopicID = 4), 8),
((SELECT $node_id FROM Articles WHERE ArticleID = 5), (SELECT $node_id FROM ResearchTopics WHERE TopicID = 8), 7);

SELECT a.Title, a.YearPublished
FROM Authors author, Wrote w, Articles a
WHERE MATCH(author-(w)->a)
AND author.Name = '������ �.�.'
ORDER BY a.YearPublished DESC;

SELECT citing.Title AS CitingArticle, citing.YearPublished
FROM Articles original, Cited c, Articles citing
WHERE MATCH(original<-(c)-citing)
AND original.Title = '������������ ������ ������� ������'
ORDER BY citing.YearPublished;

SELECT rt.TopicName
FROM Articles a, RelatedTo r, ResearchTopics rt
WHERE MATCH(a-(r)->rt)
AND a.Title = '�������������� � �������� ��������';

SELECT DISTINCT coauthor.Name
FROM Authors main, Wrote w1, Articles art, Wrote w2, Authors coauthor
WHERE MATCH(main-(w1)->art<-(w2)-coauthor)
AND main.Name = '������� �.�.'
AND coauthor.Name <> main.Name;

SELECT a.Title, a.YearPublished
FROM ResearchTopics rt, RelatedTo r, Articles a
WHERE MATCH(rt<-(r)-a)
AND rt.TopicName = '������������� ���������'
ORDER BY a.CitationCount DESC;


SELECT 
    Author1.Name AS Researcher,
    STRING_AGG(Author2.Name, ' -> ') WITHIN GROUP (GRAPH PATH) AS CollaborationPath
FROM 
    Authors AS Author1,
    Wrote FOR PATH AS w,
    Articles FOR PATH AS art,
    Wrote FOR PATH AS w2,
    Authors FOR PATH AS Author2
WHERE 
    MATCH(SHORTEST_PATH(Author1(-(w)->art<-(w2)-Author2)+))
    AND Author1.Name = '������ �.�.';

SELECT
    Original.Title AS SourceArticle,
    STRING_AGG(CitedArticle.Title, ' -> ') WITHIN GROUP (GRAPH PATH) AS CitationPath
FROM
    Articles AS Original,
    Cited FOR PATH AS c,
    Articles FOR PATH AS CitedArticle
WHERE
    MATCH(SHORTEST_PATH(Original(-(c)->CitedArticle){1,2}))
    AND Original.Title = '������������ ������ ������� ������'

SELECT A1.ArticleId AS IdFirst
	, A1.title AS First
	, CONCAT(N'article (', A1.ArticleId, ')') AS [First image name]
	, A2.ArticleId AS IdSecond
	, A2.title AS Second
	, CONCAT(N'article (', A2.ArticleId, ')') AS [Second image name]
FROM Articles AS A1
	, Cited AS c
	, Articles AS A2
WHERE MATCH(A1-(c)->A2)

SELECT A.ArticleId AS IdSecond
	, A.title AS Second
	, CONCAT(N'article (', A.ArticleId, ')') AS [Second image name]
	, R.TopicId AS IdFirst
	, R.topicName AS First
	, CONCAT(N'topic (', R.TopicId, ')') AS [First image name]
FROM Articles AS A
	, RelatedTo AS rt
	, ResearchTopics AS R
WHERE MATCH(A-(rt)->R)

SELECT A.AuthorId AS IdFirst
	, A.name AS First
	, CONCAT(N'author (', A.AuthorId, ')') AS [First image name]
	, Ar.ArticleId AS IdSecond
	, Ar.title AS Second
	, CONCAT(N'article (', Ar.ArticleId, ')') AS [Second image name]
FROM Authors AS A
	, Wrote AS w
	, Articles AS Ar
WHERE MATCH(A-(w)->Ar)