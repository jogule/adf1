ALTER TABLE
    dbo.Sales_LOAD DROP COLUMN PipelineRunId;

ALTER TABLE
    dbo.Sales_LOAD
ADD
    RunSeqNo INT;