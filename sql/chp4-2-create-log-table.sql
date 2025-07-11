CREATE TABLE
  dbo.PipelineExecution (
    RunSeqNo INT IDENTITY PRIMARY KEY,
    PipelineRunId UNIQUEIDENTIFIER UNIQUE NOT NULL,
    RunStartDateTime DATETIME NULL,
    RunEndDateTime DATETIME NULL,
    RunStatus NVARCHAR (20) NULL,
    FilesRead INT NULL,
    RowsRead INT NULL,
    RowsCopied INT NULL,
    Comments NVARCHAR (1024) NULL
  );