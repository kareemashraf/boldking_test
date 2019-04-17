<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Support\Facades\DB;
use Carbon;
use Response;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;


   /**
   * test number 1
   * Create an order based on subscription next order date
   * TODO: to be used within a Cronjob
   **/ 
    public function nextorder()
    {
    	//first get todays date
    	$mytime = Carbon\Carbon::now();
    	$today  = $mytime->toDateString();

        $results = DB::select('SELECT * from Subscriptions WHERE nextorder_date = ? AND active = "y" ', [$today]);
        
        if (!empty($results)) {
        var_dump($results);		
        		//Loop through all the orders of today
        		foreach ($results as $key => $value) {

        			$customer_id = $value->customer_id;
        			$subscription_id = $value->id;
        			$day_iteration   = $value->day_iteration;

        			$orders = DB::select('SELECT * from Orders WHERE customer_id = ? AND subscription_id = ? ', [$customer_id,$subscription_id]);
					
					if ($orders) {
								DB::update('UPDATE Orders set status = "created" WHERE customer_id = ? AND subscription_id = ?', [$customer_id,$subscription_id]);			
								}else{
									// insert a new order
								DB::insert('INSERT into Orders (customer_id, subscription_id,status,total) values (?, ?,"created",1)',[$customer_id,$subscription_id]);	
								}					
					
        			// test 2 : Set customer’s next subscription (next order date) based on customer’s day iteration

								$newdate = $mytime->addDays($day_iteration);
								$newdate = $newdate->toDateString();

								DB::update('UPDATE Subscriptions set nextorder_date = ? WHERE id = ?', [$newdate,$subscription_id]);	
								echo "Customer's next order date has been updated";
        		}

        	}	
    }

    /**
    * test 4 : Get customers last paid order date
    * to be interactive on html page within ajax
    * /lastpaidDate Route
    **/
    public function last_paid_date(){
    	$customers_id = 2;
		$results = DB::select('SELECT max(paid_date) as paid_date from Orders WHERE customer_id = ? and status = "paid" ', [$customers_id]);
		
		return $results;
    }


     /**
    * test 5 : Get all customers with more than one paid order
    * 
    * /allpaidcustomers Route
    **/
    public function allPaidCustomers(){
    	
    	//expected output is null as currently no customers with more than one paid order
		$results = DB::select('SELECT c.* from Customers c LEFT JOIN Orders o  ON o.`customer_id` = c.`id` WHERE o.`status` = "paid" GROUP BY o.`customer_id` HAVING count(o.`customer_id`) > 1 ',[]);
		
		return $results;
    }



     /**
    * test 6 : Get all customers with an active subscription and with at least one paid order
    * 
    * /allpaidcustomers Route
    **/
    public function allsubscripedCustomers(){
    	
    	//expected output is null as currently no customers with an active subscription and with at least one paid order
		$results = DB::select('SELECT c.* from Customers c LEFT JOIN Subscriptions s  ON s.`customer_id` = c.`id` LEFT JOIN Orders o on o.`customer_id` = c.`id` WHERE s.`active` = "y" AND o.`status` = "paid" GROUP BY o.`customer_id` HAVING count(o.`customer_id`) > 1 ',[]);
		
		return $results;
    }



    /**
    * test 7 : Get all customers with an active subscription and with at least one paid order
    * to be used in a Cronjob once every 24 hours.
    * /delivery Route
    **/
    public function delivery(){
    	
    	// first get all the paid orders with the paid_date of today

    	$mytime = Carbon\Carbon::now();
    	$today  = $mytime->toDateString();

    	$orders = DB::select('SELECT * from Orders WHERE status = "paid" AND paid_date = ? ', [$today]);

    	//now loop through the orders and insert into Delivery table

    	if (!empty($orders)) {
    		foreach ($orders as $key => $order) {
    			DB::insert('INSERT into Delivery (order_id,delivery_date,status) values (?,?,"pending")',[$order->id,$today]); 
    			//the status is pending till further confirmation 
    			echo "inserted new delivery record";
    		}
    	}
		
    }


    /**
    * test 8 : Export Delivery to CSV
    * 
    * /export_delivery Route
    **/
    public function export_delivery(Response $response){
    
	    $deliveries = DB::select('SELECT * from Delivery ', []);

	    $filename = "delivery.csv";
	    $handle = fopen($filename, 'w+');
	    fputcsv($handle, array('id', 'order_id', 'delivery_date', 'status'));

	    foreach($deliveries as $row) {
	        fputcsv($handle, array($row->id, $row->order_id, $row->delivery_date, $row->status));
	    }

	    fclose($handle);

	    $headers = array(
	        'Content-Type' => 'text/csv',
	    );

	    return Response::download($filename, 'delivery.csv', $headers);
    }

}
