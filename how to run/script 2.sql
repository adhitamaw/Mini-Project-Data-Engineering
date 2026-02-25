create schema third_party;

-- ini yang latihan cuy yang pake etl program python, data nya dari repositopory 

-- transformasi elt
create table iris_transformed as 
select "sepal length" , "sepal width"  from iris_elt;