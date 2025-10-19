USE dz3;

SELECT 
    od.*,
    (SELECT o.customer_id 
     FROM orders o 
     WHERE o.id = od.order_id
    ) AS customer_id
FROM order_details od;

SELECT od.*  FROM order_details od
WHERE (SELECT orders.shipper_id FROM orders WHERE orders.id=od.order_id )=3;

SELECT 
    order_id,
    AVG(quantity) AS avg_quantity
FROM (
    SELECT *
    FROM order_details
    WHERE quantity > 10
) AS sub
GROUP BY order_id;

WITH temp AS (
    SELECT *
    FROM order_details
    WHERE quantity > 10
)
SELECT 
    order_id,
    AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

DROP FUNCTION IF EXISTS divide_values;

DELIMITER $$

CREATE FUNCTION divide_values(a FLOAT, b FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE result FLOAT;
    IF b = 0 THEN
        SET result = NULL; -- або можна повернути 0
    ELSE
        SET result = a / b;
    END IF;
    RETURN result;
END$$

DELIMITER ;

SELECT 
    order_id,
    quantity,
    divide_values(quantity, 5) AS divided_value
FROM order_details;
