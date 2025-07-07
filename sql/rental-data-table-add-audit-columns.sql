ALTER TABLE [dbo].[rental_data]
ADD PipelineRunId UNIQUEIDENTIFIER NULL
  , SourceFileName NVARCHAR(1024) NULL;