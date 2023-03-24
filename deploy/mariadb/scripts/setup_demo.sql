CREATE TABLE Album
(
    AlbumId INT NOT NULL,
    Title VARCHAR(160) NOT NULL,
    ArtistId INT NOT NULL
);

CREATE TABLE Artist
(
    ArtistId INT NOT NULL,
    Name VARCHAR(120)
);
