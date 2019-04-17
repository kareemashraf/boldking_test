
INSERT INTO `Customers` (`id`, `name`, `email`, `subscriptions`, `active`)
VALUES
  (1,'Bruce Wayne','bruce@boldking.com ',NULL,'y'),
  (2,'Diana Prince ','diana@boldking.com',1,'y'),
  (3,'Tony Stark ','tony@boldking.com ',2,'y'),
  (4,'Peter Parker ','peter@boldking.com ',3,'y');


INSERT INTO `Subscriptions` (`id`, `customer_id`, `start_date`, `nextorder_date`, `day_iteration`, `active`)
VALUES
  (1,2,'2018-08-01','2019-02-02',30,'n'),
  (2,3,'2018-04-01','2019-03-21',40,'y'),
  (3,4,'2019-03-06','2019-03-26',20,'y');


INSERT INTO `Orders` (`id`, `customer_id`, `subscription_id`, `status`, `total`, `paid_date`)
VALUES
  (1,2,1,'failed',50,'2018-12-15'),
  (2,1,NULL,'paid',100,'2019-01-03'),
  (3,3,2,'paid',10,'2019-02-11'),
  (4,2,NULL,'paid',20,'2019-03-04'),
  (5,4,3,'created',30,'2019-03-06');


