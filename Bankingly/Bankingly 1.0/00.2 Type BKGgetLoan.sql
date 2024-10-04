


IF EXISTS (SELECT 1 FROM sys.types WHERE name = 'BKGgetLoan')
    DROP TYPE BKGgetLoan
GO

CREATE TYPE BKGgetLoan AS TABLE(
		AccountBankIdentifier		VARCHAR(32),		
		CurrentBalance				NUMERIC(23,8),
		CurrentRate  				NUMERIC(18,2),
		FeesDue						INT,
		-- BEGIN FeesDueData		
		FeesDueInterestAmount		NUMERIC(18,2),
		FeesDueOthersAmount			NUMERIC(23,8),
		FeesDueOverdueAmount		NUMERIC(23,8),
		FeesDuePrincipalAmount		NUMERIC(23,8),
		FeesDueTotalAmount			NUMERIC(23,8),
		-- END FeesDueData
		LoanStatusId				INT,
		-- BEGIN NextFee - LoanFee
		CapitalBalance				NUMERIC(23,8),
		FeeNumber					INT,
		PrincipalAmount				NUMERIC(23,8),
		DueDate						DATE,
		InterestAmount				NUMERIC(23,8),
		OverdueAmount				NUMERIC(23,8),
		FeeStatusId					INT,
		OthersAmount				NUMERIC(23,8),
		TotalAmount					NUMERIC(23,8),
		-- END NextFee - LoanFee
		OriginalAmount				NUMERIC(18,2),
		OverdueDays					INT,
		PaidFees					INT,
		PayoffBalance				NUMERIC(23,8),
		PrepaymentAmount			NUMERIC(23,8),
		ProducttBankIdentifier		VARCHAR(32),
		Term						int,
		ShowPrincipalInformation	bit
)
GO

