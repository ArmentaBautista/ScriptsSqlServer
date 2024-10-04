


if not exists(select 1
            from tCREDproductosFinancierosAutomaticos a WITH (NOLOCK)
            where a.IdProductoFinanciero in (4,5))
begin
     INSERT INTO tCREDproductosFinancierosAutomaticos (IdProductoFinanciero, EsSobreInversion, IdEstatus,IdSesion)
     VALUES
         (4,0,1,0),
         (5,1,1,0)
END

if not exists(select 1
            from tCREDproductosFinancierosGrupales g WITH (NOLOCK)
            where g.IdProductoFinanciero in (2))
begin
     INSERT INTO tCREDproductosFinancierosGrupales (IdProductoFinanciero, IdEstatus,IdSesion) VALUES (2,1,0)
END


select * from tCREDproductosFinancierosAutomaticos a WITH (NOLOCK)
select * from tCREDproductosFinancierosGrupales a WITH (NOLOCK)




