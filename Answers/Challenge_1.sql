use AdventureWorks2012
go

drop table #tmp_SalesOrderHeader

select SalesPersonID, startDate = DATEPART(year, OrderDate), endDate = DATEPART(year, DATEADD(year, 1, OrderDate)), sumSubTotal = sum(SubTotal)
into #tmp_SalesOrderHeader
from Sales.SalesOrderHeader
	where DATEPART(QUARTER, OrderDate) = 2 and OnlineOrderFlag <> 1
	group by SalesPersonID, DATEPART(year, OrderDate), DATEPART(year, DATEADD(year, 1, OrderDate))


select N1.SalesPersonID, CONCAT(n3.FirstName, ' ', n3.LastName), start_year = N2.startDate, end_year = N1.startDate, N2.sumSubTotal, N1.sumSubTotal, change = 100 * (N1.sumSubTotal - N2.sumSubTotal) / N2.sumSubTotal
from #tmp_SalesOrderHeader N1
	join #tmp_SalesOrderHeader N2 on N1.SalesPersonID = N2.SalesPersonID
	and N1.startDate - 1 = N2.startDate
	join Person.Person N3 on N1.SalesPersonID = N3.BusinessEntityID
	where N1.startDate = 2012
	
