-- Create the database
CREATE DATABASE MobyDickAnalysis;
GO

USE MobyDickAnalysis;
GO

-- Create the WordFrequency table with computed WordLength column
CREATE TABLE WordFrequency (
    Id INT PRIMARY KEY IDENTITY(1,1),
    Word NVARCHAR(50) NOT NULL,
    Frequency INT NOT NULL,
    WordLength AS LEN(Word)
);
GO

-- Stored procedure to insert or update word frequency
CREATE PROCEDURE InsertOrUpdateWordFrequency
    @Word NVARCHAR(50),
    @Frequency INT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM WordFrequency WHERE Word = @Word)
    BEGIN
        UPDATE WordFrequency
        SET Frequency = Frequency + @Frequency
        WHERE Word = @Word;
    END
    ELSE
    BEGIN
        INSERT INTO WordFrequency (Word, Frequency)
        VALUES (@Word, @Frequency);
    END
END;
GO

-- Stored procedure to get the most frequent word
CREATE PROCEDURE GetMostFrequentWord
AS
BEGIN
    SELECT TOP 1 Word, Frequency
    FROM WordFrequency
    ORDER BY Frequency DESC;
END;
GO

-- Stored procedure to get the most frequent seven-letter word
CREATE PROCEDURE GetMostFrequentSevenLetterWord
AS
BEGIN
    SELECT TOP 1 Word, Frequency
    FROM WordFrequency
    WHERE WordLength = 7 
    ORDER BY Frequency DESC;
END;
GO

-- Create the function to calculate Scrabble score
CREATE FUNCTION CalculateScrabbleScore(@Word NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @Score INT = 0;
    DECLARE @i INT = 1;

    WHILE @i <= LEN(@Word)
    BEGIN
        DECLARE @Char CHAR(1) = SUBSTRING(@Word, @i, 1);
        SET @Score = @Score +
            CASE @Char
                WHEN 'A' THEN 1 WHEN 'E' THEN 1 WHEN 'I' THEN 1 WHEN 'O' THEN 1 WHEN 'U' THEN 1
                WHEN 'L' THEN 1 WHEN 'N' THEN 1 WHEN 'S' THEN 1 WHEN 'T' THEN 1 WHEN 'R' THEN 1
                WHEN 'D' THEN 2 WHEN 'G' THEN 2
                WHEN 'B' THEN 3 WHEN 'C' THEN 3 WHEN 'M' THEN 3 WHEN 'P' THEN 3
                WHEN 'F' THEN 4 WHEN 'H' THEN 4 WHEN 'V' THEN 4 WHEN 'W' THEN 4 WHEN 'Y' THEN 4
                WHEN 'K' THEN 5
                WHEN 'J' THEN 8 WHEN 'X' THEN 8
                WHEN 'Q' THEN 10 WHEN 'Z' THEN 10
                ELSE 0
            END;
        SET @i = @i + 1;
    END;

    RETURN @Score;
END;
GO

-- Stored procedure to get the highest Scrabble scoring words
CREATE PROCEDURE GetHighestScrabbleScoringWords
AS
BEGIN
    DECLARE @MaxScore INT;
    
    SELECT @MaxScore = MAX(Score)
    FROM WordFrequency
    CROSS APPLY (SELECT dbo.CalculateScrabbleScore(Word) AS Score) AS ScrabbleScores;

    SELECT Word, Frequency, Score AS ScrabbleScore
    FROM WordFrequency
    CROSS APPLY (SELECT dbo.CalculateScrabbleScore(Word) AS Score) AS ScrabbleScores
    WHERE Score = @MaxScore;
END;
GO

-- Create necessary indexes for optimization
CREATE INDEX IX_WordFrequency_Word ON WordFrequency(Word);

CREATE INDEX IX_WordFrequency_Frequency ON WordFrequency(Frequency);

CREATE INDEX IX_WordFrequency_WordLength ON WordFrequency(WordLength);
GO
