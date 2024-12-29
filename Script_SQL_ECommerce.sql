-- Etapa 1) criação do banco de dados para o cenário de E-commerce
create database Ecommerce;
use ecommerce;

-- criar tabela Cliente, endo que o campo documento poderá ser preenchido ou com CPF ou com CNPJ, por isso é um campo único e para identificação e validação do sistema, temos o campo tipo de cliente
create table clients(
		idClient int auto_increment primary key,
        FnameClient varchar(20) not null,
        LnameClient varchar(50) not null,
        TypeClient enum('Pessoa Física', 'Pessoa Jurídica') default 'Pessoa Física',
        DocClient varchar(14) not null,
        BillingAddressClient varchar(20) not null,
        DeliveryAddressClient varchar(20) not null,
        PhoneClient char(11) not null,
        EmailClient varchar(50),        
        constraint unique_DocClient unique (DocClient)      
);

alter table clients auto_increment=1;

-- criar tabela Fornecedor
create table supplier(
		idSupplier int auto_increment primary key,
        CorporateNameSupplier varchar(255) unique not null,
        DocSupplier char(14) not null,
        AddressSupplier varchar(100) not null,
        PhoneSupplier char(11) not null,
        EmailSupplier varchar(50),        
        constraint unique_DocSupplier unique (DocSupplier) 
);

alter table supplier auto_increment=1;

-- criar tabela Vendedor Parceiro/Terceiro 
create table partnerSeller(
		idPartnerSeller int auto_increment primary key,
        SalesNamePartnerSeller varchar(100) not null,
        CorporateNamePartnerSeller varchar(255) not null,
        DocPartnerSeller char(14) not null,
        AddressPartnerSeller varchar(100) not null,
        PhonePartnerSeller char(11) not null,
        EmailPartnerSeller varchar(50),        
        constraint unique_CorporateNamePartnerSeller unique (CorporateNamePartnerSeller),
        constraint unique_DocPartnerSeller unique (DocPartnerSeller)
);

alter table partnerSeller auto_increment=1;

-- criar tabela Produto
create table product(
		idProduct int auto_increment primary key,
        NameProduct  varchar(50) not null,
        CategoryProduct enum('Eletrônico', 'Livro', 'Roupa', 'Calçado', 'Esportes', 'Brinquedos', 'Beleza', 'Casa', 'Pet') not null,
        ClassificationKids bool not null,
        DescriptionProduct varchar(255) not null,
        PriceProduct float not null,
        AvailableProduct bool default True,
        SizeProduct varchar(15),        
        constraint unique_NameProduct unique (NameProduct)
);

alter table product auto_increment=1;

-- criar tabela Estoque
create table stock(
		idStock int auto_increment primary key,
        LocationNameStock  varchar(50) not null,
        AddressStock  varchar(100) not null,
        PhoneStock  char(11) not null,
        constraint unique_LocationNameStock unique (LocationNameStock)
);

alter table stock auto_increment=1;

-- criar tabelas Pedido 
create table orders(
		idOrder int auto_increment primary key,
        Clients_idClient int not null,
        DescriptionOrder  varchar(200) not null,
        StatusOrder enum('Em Processamento', 'Pendente', 'Confirmado', 'Concluído', 'Cancelado') default 'Em Processamento',
		constraint fk_order_client foreign key (Clients_idClient) references Clients(idClient) 
				on update cascade
);

alter table orders auto_increment=1;

-- criar tabela Pagamento
create table payment(
		idPayment int auto_increment primary key,
        Orders_idOrder int not null,
        ValuePaid  float not null,
        TypePayment enum('PIX', 'Cartão de Débito', 'Cartão de Crédito à vista', 'Cartão de Crédito parcelado 10 vezes sem juros') default 'PIX',
		AuthorizationCode varchar(50),
        StatusPayment enum('Pendente', 'Pago', 'Estornado'),
        DatePayment datetime,
        DateRefund datetime,
        constraint fk_payment_order foreign key (Orders_idOrder) references Orders(idOrder)
);     

alter table payment auto_increment=1;
        
-- criar tabelas Entrega
create table delivery(
		idDelivery int auto_increment primary key,
        Orders_idOrder int not null,
        PriceDelivery  float not null,
        StatusDelivery enum('Aguardando Envio', 'Em transito', 'Entregue', 'Devolvido') default 'Aguardando Envio',
		DateDelivery datetime,
        DateReturn datetime,
        ReasonReturn varchar(255),
        constraint fk_delivery_order foreign key (Orders_idOrder) references Orders(idOrder)
);  

alter table delivery auto_increment=1;

-- criar tabelas Cancelamento Pedido 
create table cancelOrder(
		idCancelOrder int auto_increment primary key,
        Orders_idOrder int not null,
        DateCancelOrder datetime,
        ReasonCancelOrder varchar(255),
        constraint fk_cancelOrder_order foreign key (Orders_idOrder) references Orders(idOrder)
);  

alter table cancelOrder auto_increment=1;

-- criar tabela Relação Produto/Fornecedor
create table productSupplier(
		Supplier_idSupplier int,
        Product_idProduct int,
        primary key (Supplier_idSupplier,  Product_idProduct),
        constraint fk_product_supplier foreign key (Supplier_idSupplier) references Supplier(idSupplier),
        constraint fk_product_product foreign key (Product_idProduct) references Product(idProduct)
);  

-- criar tabela Relação Produto/Vendedor
create table productPartnerSeller(
		PartnerSeller_idPartnerSeller int,
        Product_idProduct int,
        primary key (PartnerSeller_idPartnerSeller, Product_idProduct),
        constraint fk_product_PartnerSeller foreign key (PartnerSeller_idPartnerSeller) references PartnerSeller(idPartnerSeller),
        constraint fk_product_product_seller foreign key (Product_idProduct) references Product(idProduct)
);  

-- criar tabela Relação Produto/Estoque
create table productStock(
		Product_idProduct int,
        Stock_idStock int,
		Delivery_idDelivery int default '0',
        QuantStock int default '0',
        QuantSeller int default  '0',
        primary key (Product_idProduct, Stock_idStock, Delivery_idDelivery),
	    constraint fk_product_stock foreign key (Stock_idStock) references Stock(idStock),
        constraint fk_product_delivery foreign key (Delivery_idDelivery) references Delivery(idDelivery),
        constraint fk_product_product_Stock foreign key (Product_idProduct) references Product(idProduct)
);  

-- criar tabela Relação Produto/Pedido
create table productOrder(
		Product_idProduct int,
        Orders_idOrder int,
		QuantOrder int not null,
        primary key (Product_idProduct, Orders_idOrder ),
	    constraint fk_product_Order foreign key (Orders_idOrder) references Orders(idOrder),
        constraint fk_product_product_Order foreign key (Product_idProduct) references Product(idProduct)
);  

-----------------------------------------------------------------
-- Etapa 2) Verificação e ajustes nas tabelas criadas
-- comando para visualizar uma tabela específica já criada:
desc clients;
desc supplier;
desc partnerSeller;
desc product;
desc stock;
desc orders;
desc payment;
desc delivery;
desc cancelOrder;
desc productSupplier;
desc  productPartnerSeller;
desc productStock;
desc productOrder;

-- comando para apagar o database: 
drop database Ecommerce;

-- comando para visualizar tabelas:
show tables;

-- comando para visualizar os databases:
show databases;

-- comandos para explorar os databases:
use information_schema;

show tables;

desc table_constraints;

desc REFERENTIAL_CONSTRAINTS;

select * from REFERENTIAL_CONSTRAINTS where constraint_schema = 'Ecommerce'; 
      
SELECT COLUMN_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'Ecommerce'
AND TABLE_NAME = 'orders';

---------------------------------------
-- Etapa 3) inserir dados nas tabelas criadas
use Ecommerce;

insert into clients (FnameClient, LnameClient, TypeClient, DocClient, BillingAddressClient, DeliveryAddressClient, PhoneClient, EmailClient)
		values ('João', 'Menezes', 'Pessoa Física', '23545698503', 'R.11, 2020 - CPS', 'R.11, 2020 - CPS', '11956234852', null),
			   ('Aline', 'Claridez', 'Pessoa Jurídica', '23545698503012', 'R.750, 3 - CPS', 'R.8520, 350 - CPS', '11965231456', 'alcla@kol.com'),
			   ('Tião', 'Solene', 'Pessoa Física', '852145698', 'R.95412, 30 - CPS', 'R.95412, 30 - CPS', '11979864136', 'ts@ts.com.br');

insert into product (NameProduct, CategoryProduct, ClassificationKids, DescriptionProduct, PriceProduct, AvailableProduct, SizeProduct)
		values ('Fone', 'Eletrônico', '0', 'Marca Y - garantia X', '1500', '5', null),
			   ('Armário', 'Casa', '0', 'Marca ZZ - garantia X', '850', null, '10 x 30 x 50cm'),
			   ('Agora', 'Livro', '1', 'Editora hj - 1500pgs', '150', '3', '2 x 30 x 30cm');

insert into partnerSeller (SalesNamePartnerSeller, CorporateNamePartnerSeller, DocPartnerSeller, AddressPartnerSeller, PhonePartnerSeller, EmailPartnerSeller)
		values ('Linda Flor Livraria', 'LFLivraria LTDA', '12358964725698', 'R.258, N.25 - HJO', '11258632594', null),
			   ('Aqui Brinca Mto', 'ABM Ltda', '59764823695124', 'R.5862, N.2502 - HJO', '11456982364', ' abm@abm.com'),
			   ('xpto sei lá', 'XSL SA', '59987456952345', 'R.62, N.2 - HJO', '11856942365', 'XSL@XSL.com');

insert into supplier (CorporateNameSupplier, DocSupplier, AddressSupplier, PhoneSupplier, EmailSupplier)
		values ('ELIT LTDA', '12374164455698', 'R.11258, N.2575 - HJO', '11258678694', null),
			   ('AHKPO Ltda', '54852823646124', 'R.62, N.25 - HJO', '11457532364', ' aline@ahkpo.com'),
			   ('XSLYL SA', '57412453698345', 'R.8627, N.125 - HJO', '11845644565', 'vendas@xslyl.com');
               
insert into stock (LocationNameStock, AddressStock,PhoneStock)		
		values ('StockOne','R. Sem Fim, 258-CPS','31258634598');
				
insert into orders (Clients_idClient, DescriptionOrder, StatusOrder)		
		values (1, 'Fone de Ouvido', default),
			   (3, 'Armário da Barbie', 'Confirmado'),
			   (2, 'xpto agora', 'Concluído');
               
insert into payment (Orders_idOrder, ValuePaid, TypePayment, StatusPayment, DatePayment, DateRefund, AuthorizationCode)		
		values (1, '1515', 'Cartão de Crédito parcelado 10 vezes sem juros', 'Pago', '2025-12-20 12:12:12', null, 589 ),
			   (3, '865', 'Cartão de Crédito à vista', 'Pendente','2025-12-20 10:12:12', null, 595 ),
			   (2, '165', 'PIX', 'Pago', '2025-12-20 11:12:12', null, 890 );
               
insert into delivery (Orders_idOrder, PriceDelivery, StatusDelivery, DateDelivery, DateReturn, ReasonReturn   )		
		values (1, '15', 'Em Transito', '2025-12-28 12:12:12', null, null ),
			   (3, '15', 'Aguardando Envio','2025-12-30 12:12:12', null, null ),
			   (2, '15', 'Entregue','2025-12-25 12:12:12', null, null );
            
insert into productStock (Product_idProduct, Stock_idStock, Delivery_idDelivery,QuantStock,QuantSeller)		
		values (7,1,3,1,null),
			   (9,1,2,1,null),
			   (8,1,1,null,1);
               
insert into orders (Clients_idClient, DescriptionOrder, StatusOrder)		
		values (2, 'Fone de Ouvido', default);
        
insert into clients (FnameClient, LnameClient, TypeClient, DocClient, BillingAddressClient, DeliveryAddressClient, PhoneClient, EmailClient)
		values ('Tatiana', 'Apolo', 'Pessoa Física', '23852868503', 'R.1120, 30 - CPS', 'R.1120, 30 - CPS', '11959563852', null);
        
insert into productOrder (Product_idProduct, Orders_idOrder, QuantOrder)		
		values (7,1,1),
			   (9,3,1),
			   (8,2,1),
			   (7,4,2);
               
insert into partnerSeller (SalesNamePartnerSeller, CorporateNamePartnerSeller, DocPartnerSeller, AddressPartnerSeller, PhonePartnerSeller, EmailPartnerSeller)
               values ('ELIT', 'ELIT LTDA', '12374164455698', 'R.11258, N.2575 - HJO', '11258678694', null);
               
insert into ProductSupplier (Supplier_idSupplier, Product_idProduct)		
		values (2,7),
			   (1,8),
			   (3,9),
			   (2,13);
               
insert into delivery (idDelivery, Orders_idOrder, PriceDelivery, StatusDelivery, DateDelivery, DateReturn, ReasonReturn   )		
		values (4, 4, '15', 'Em Transito', '2025-12-28 12:12:12', null, null );
               
insert into productStock (Product_idProduct, Stock_idStock, Delivery_idDelivery,QuantStock,QuantSeller)		
		values (8,1,4,1,null);
        
insert into stock (LocationNameStock, AddressStock,PhoneStock)		
		values ('StockTwo','R. Agora Vai, 520-CPS','31256842598');
        
insert into productStock (Product_idProduct, Stock_idStock, Delivery_idDelivery,QuantStock,QuantSeller)		
		values (8,2,1,1,null);
               
-----------------------------------------------------------------
-- Etapa 4)  Verificação e ajustes nos dados inseridos

-- comando para verificar dados na tabela
SELECT * FROM clients;
SELECT * FROM supplier;
SELECT * FROM partnerSeller;
SELECT * FROM product;
SELECT * FROM stock;
SELECT * FROM orders;
SELECT * FROM payment;
SELECT * FROM delivery;
SELECT * FROM productStock;
SELECT * FROM productOrder; 
SELECT * FROM productSupplier; 
-- tabelas sem dados
SELECT * FROM cancelOrder;
SELECT * FROM productPartnerSeller;

-- para deletar dados da tabela
delete from orders where idOrderClient in (1,2,3);    

------------------------------------------------------
-- Etapa 5) Queries 

-- 1) Verificar total de clientes cadastrados
select count(*) from clients;

-- 2) Verificar total de pedidos cadastrados
select count(*) from orders;

-- 3) Mostrar todos os dados dos clientes e com os seus pedidos
select * from clients c, orders o where c.idClient = o.Clients_idClient;

-- 4) Especificar apenas alguns atributos dos clientes e seus pedidos
select FnameClient, LnameClient, idOrder, StatusOrder from clients c, orders o where c.idClient = o.Clients_idClient;

-- 5) Concatenar o nome e melhorar a visão dos atributos dos clientes e seus pedidos
select concat(FnameClient, ' ', LnameClient) as Client, idOrder as Request, StatusOrder as Status from clients c, orders o where c.idClient = o.Clients_idClient;

-- 6) Verificar quantos pedidos por cliente
SELECT CONCAT(FnameClient, ' ', LnameClient) AS Client, COUNT(*)
     FROM clients c, orders o
     WHERE c.idClient = o.Clients_idClient
   GROUP BY idClient;

-- 7) Verificar todos os clientes cadastrados e seus pedidos, recuperar todos os clientes com ou sem pedidos realizados
select * from clients left outer join orders on idClient = idOrder;

-- 8) Verificar quantidade total de pedidos por cliente
select c.idClient, FnameClient, count(*) as Number_of_Order from clients c 
		inner join orders o on c.idClient = o.Clients_idClient
		inner join productOrder p on p.Orders_idORder = o.idOrder
	group by idClient;

-- 9) Verificar a quantidade de pedidos por cliente, recuperar todos os clientes com ou sem pedidos realizados
SELECT c.FnameClient, c.LnameClient, COUNT(o.idOrder) AS TotalPedidos
		FROM Clients c
		LEFT JOIN Orders o ON c.idClient = o.Clients_idClient
	GROUP BY c.idClient, c.FnameClient, c.LnameClient;

-- 10) Algum vendedor também é fornecedor
SELECT s.CorporateNameSupplier AS NomeFornecedor, p.CorporateNamePartnerSeller AS NomeVendedor
		FROM Supplier s
		INNER JOIN PartnerSeller p ON s.DocSupplier = p.DocPartnerSeller;

-- 11) Verificar a relação de produtos, fornecedores e estoques
SELECT s.CorporateNameSupplier AS Fornecedor, p.NameProduct, e.LocationNameStock, pe.QuantStock, pe.QuantSeller
	FROM Supplier s
	INNER JOIN ProductSupplier ps ON s.idSupplier = ps.supplier_idSupplier
	INNER JOIN Product p ON ps.Product_idProduct = p.idProduct
    LEFT JOIN ProductStock pe ON p.idProduct = pe.Product_idProduct
	LEFT JOIN Stock e ON pe.stock_idstock = e.idstock;
    
-- 12) Relação de nomes dos fornecedores e nomes dos produtos
    SELECT s.CorporateNameSupplier AS Fornecedor, p.NameProduct
		FROM Supplier s
		INNER JOIN ProductSupplier ps ON s.idSupplier = ps.supplier_idSupplier
		INNER JOIN Product p ON ps.Product_idProduct = p.idProduct;

-- 13) Quantos produtos estão disponíveis em cada local de armazenamento
SELECT e.LocationNameStock, 
    SUM(pe.QuantStock) AS TotalEstoque
    FROM Stock e
    LEFT JOIN ProductStock pe ON e.idStock = pe.Stock_idStock
  GROUP BY e.LocationNameStock;
  
-- 14) Quantos pordutos (por nome)estão disponíveis em cada local do armazenamento
  SELECT e.LocationNameStock As Local_Estoque, p.NameProduct AS Produto,
		SUM(pe.QuantStock) AS TotalEstoque
		FROM Stock e
		LEFT JOIN ProductStock pe ON e.idStock = pe.Stock_idStock
		INNER JOIN product p ON  p.idProduct = pe.Product_idProduct
    GROUP BY e.LocationNameStock, p.NameProduct;
  
-- 15) Qual é o valor total gasto por cada cliente em pedidos
SELECT CONCAT(FnameClient, ' ', LnameClient) AS Cliente,
    SUM(pag.ValuePaid) AS TotalGasto
    FROM Clients c
    INNER JOIN Orders o ON c.idClient = o.Clients_idClient
    INNER JOIN Payment pag ON o.idOrder = pag.Orders_idOrder
	WHERE pag.StatusPayment = 'Pago'
  GROUP BY c.idClient, Cliente;

-- 16) Qual é o status de entrega mais comum nos pedidos
SELECT d.StatusDelivery, COUNT(*) AS Total
    FROM Delivery d
 GROUP BY d.StatusDelivery
 ORDER BY Total DESC;

-- 17) Quais pedidos pagos possuem valor superior a 500,00, ordenando do maior para o menor
SELECT o.idOrder, o.DescriptionOrder, pag.ValuePaid
	FROM Orders o
	INNER JOIN Payment pag ON o.idOrder = pag.Orders_idOrder
	WHERE pag.ValuePaid > 500 
	ORDER BY pag.ValuePaid DESC; 

-- 18) Quantos pedidos por cliente estão acima do limite mínimo de 1000,00
SELECT CONCAT(FnameClient, ' ', LnameClient) AS Cliente,
      COUNT(o.idOrder) AS PedidosAcimaDoLimite
      FROM Clients c
      INNER JOIN Orders o ON c.idClient = o.Clients_idClient
      INNER JOIN Payment pag ON o.idOrder = pag.Orders_idOrder
      WHERE pag.ValuePaid > 1000 
  GROUP BY c.idClient, Cliente;

-- 19) Verificar apenas clientes com mais de 1 pedido 
SELECT CONCAT(FnameClient, ' ', LnameClient) AS Cliente,
		COUNT(o.idOrder) AS TotalPedidos
		FROM Clients c
		LEFT JOIN Orders o  ON c.idClient = o.Clients_idClient
	GROUP BY c.idClient, Cliente
	HAVING COUNT(o.idOrder) > 1; 
    
-- 20) Verificar relação do Status do Pedido, pagamento e entregas
SELECT CONCAT(FnameClient, ' ', LnameClient) AS Cliente, o.DescriptionOrder, e.StatusDelivery, pag.StatusPayment
		FROM Clients c
		INNER JOIN Orders o ON c.idClient = o.Clients_idClient
		LEFT JOIN Delivery e ON o.idOrder = e.Orders_idOrder
		LEFT JOIN Payment pag ON o.idOrder = pag.Orders_idOrder
	ORDER BY Cliente, e.StatusDelivery;

