<?php

    include_once "oauth-php/library/OAuthStore.php";
    include_once "oauth-php/library/OAuthRequester.php";

    //Turn on Errors
    ini_set('display_errors', 1);
    error_reporting(E_ALL);
    class item {
        
        function __construct($upc,$name,$alias,$description,$avg_price,$count){
            $this->upc = $upc;
            $this->name = $name;
            $this->alias = $alias;
            $this->description = $description;
            $this->avg_price = $avg_price;
            $this->count = $count;
        }
        
        public function getUPC(){
            return $this->upc;
        }
        public function getName(){
            return $this->name;
        }
        public function getAlias(){
            return $this->alias;
        }
        public function getDescription(){
            return $this->description;
        }
        public function getAvgPrice(){
            return $this->avg_price;
        }
    }
    if(isset($_POST['submit']) && $_POST['submit'] == 'Submit'){
        $text = $_POST['rec']; //Submitted Data - Would come from OMNIPAGE
        $UPCS = processUPCS($text); //Array of UPCS Codes, could be 12,8,or 6 digits in length
        $items = array();
        foreach($UPCS as $upc){
            $upcinfo = getUPCInfo($upc['upc']);
            if($upcinfo->valid == 'true'){
                $item = new item($upc['upc'],$upc['name'],$upcinfo->alias,$upcinfo->description,$upcinfo->avg_price,$upc['count']);
            } else {
                $item = new item($upc['upc'],'NEW ITEM: '.$upc['name'],"","","",$upc['count']);
            }
            array_push($items,$item);
        }
        /*
        *
        *   TODO: Grab 6, 8, and 12 Digigt UPCS
        *   Fix UPCS without correct last digit
        *   Handle 6 digit UPCS - Add in MFR Number
        *
        */
        
        $found = count($UPCS); //Number of found UPC
    }
    
    function processUPCS($input) {
        //Declare arrays
        $twelve_length_upcs = array();  //123456789012
        $four_dash_upcs = array();      //1234-12345678
        $four_four_upcs = array();      //1234-4568-9012
        $eleven_length_upcs = array();  //12345678901
        $eleven_space_upcs = array();   //1234 5678901
        $eight_length_upcs = array();   //12345678
        $six_length_upcs = array();     //123456
        
        //Check for 12 Digit UPCS
        preg_match_all('/^(.*?)\s+(\d{12})(?=\D|$)/m',$input,$matches);
        $items = array();
        foreach( $matches[2] as $k => $upc) {
            if( !isset( $items[$upc])) {
                $items[$upc] = array( 'name' => $matches[1][$k], 'count' => 0);
            }
            $items[$upc]['count']++;
        }
        $twelve_length_upcs = $items;
        //If less than 2 are found maybe receipt is showing 12 digit codes with single dashes and not 12 digit codes
        if(count($twelve_length_upcs) < 2){
            preg_match_all('/(?:^|\D)(\d{4}-\d{8})(?=\D|$)/',$input,$matches);
            $four_dash_upcs = $matches[0];
            //If less than 2 are found maybe receipt is showing 11 digit codes and not 12 digit codes
            if(count($four_dash_upcs) < 2) {
                preg_match_all('/(?:^|\D)(\d{4}-\d{4}-\d{4})(?=\D|$)/',$input,$matches);
                $four_four_upcs = $matches[0];
                //If less than 2 are found maybe receipt is showing 11 digit codes and not 12 digit codes
                if(count($four_four_upcs) < 2) {
                    preg_match_all('/(?:^|\D)(\d{11})(?=\D|$)/',$input,$matches);
                    $eleven_length_upcs = $matches[0];
                    print_r($eleven_length_upcs);
                    //If less than 2 are found maybe receipt is showing 11 digit codes with spaces and not 12 or 11 digit codes
                    if(count($eleven_length_upcs) < 2){
                        preg_match_all('/(?:^|\D)(\d{4} \d{7})(?=\D|$)/',$input,$matches);
                        $eleven_space_upcs = $matches[0];
                        //If less than 2 are found maybe receipt is showing 8 digit codes and not 12 or 11 digit codes
                        if(count($eleven_space_upcs) < 2) {
                            preg_match_all('/(?:^|\D)(\d{8})(?=\D|$)/',$input,$matches);
                            $eight_length_upcs = $matches[0];
                            print_r($eight_length_upcs);
                            //If less than 2 are found maybe receipt is showing 6 digit codes and not 12,11 or 8 digit codes
                            if(count($eight_length_upcs) < 2){
                                preg_match_all('/(?:^|\D)(\d{6})(?=\D|$)/',$input,$matches);
                                $six_length_upcs = $matches[0];
                                print_r($six_length_upcs);
                            }
                        }
                    }
                }
            }
        }
        //Combined ALL Arrays from above
        return createValidUPCS(
            array_merge(
                $twelve_length_upcs,
                $four_dash_upcs,
                $four_four_upcs,
                $eleven_length_upcs,
                $eleven_space_upcs,
                $eight_length_upcs,
                $six_length_upcs
                )
            );
    }
    
    function createValidUPCS($upcs){
        $upcArray = array();
        //Loop through each UPC
        foreach($upcs as $key => $var){
            $upc = $key;
            $upc = str_replace('-','',str_replace(' ','',trim($upc))); //Clean up remove spaces and dashes
            //echo "CHECKING $upc, length:".strlen($upc).'<br/>';
            //If UPC is 11 or 12 Chars, validate
            if(strlen($upc) == 12 || strlen($upc == 11)){
                //echo "11 or 12 digit barcode<br/>";
                //Calculate Checkdigit based on current UPC
                $checkdigit = calculate_upc_check_digit($upc);
                //For full length UPC, we can compare calculated checkdigit against input checkdigit
                if(strlen($upc) == 12) {
                    //echo "Checking $checkdigit against $upc<br/>";
                    //If they match, we have a valid UPC
                    if($checkdigit == getCheckDigit($upc)){
                        //echo "Match<br/><br/>";
                        if(verifyUPCType($upc)){
                            array_push($upcArray,array('upc' => $upc, 'count' => $var['count'], 'name' => $var['name']));
                        }
                    //If they do not match, maybe it's starting with 0 and ommiting the checkdigit, calculate based on last 11
                    } else {
                        $checkdigit = calculate_upc_check_digit(substr($upc,1));
                        //echo "No Match, return calculated version UPC which is ".substr($upc,1).$checkdigit."<br/><br/>";
                        $upc = substr($upc,1).$checkdigit;
                        if(verifyUPCType($upc)){
                            array_push($upcArray,array('upc' => $upc, 'count' => $var['count'], 'name' => $var['name']));
                        }
                    }
                } elseif (strlen($upc) == 11){
                    //echo "11 long, Calculating<br/><br/>";
                    $upc = $upc.$checkdigit;
                    if(verifyUPCType($upc)){
                        array_push($upcArray,array('upc' => $upc, 'count' => $var['count'], 'name' => $var['name']));
                    }
                }
            } elseif (strlen($upc) == 8) {
                echo "8 digit barcode<br/>";
                //Calculate Checkdigit based on current UPC
                $checkdigit = calculate_upc_check_digit($upc);
                //echo "Checking $checkdigit against $upc<br/>";
                if($checkdigit == getCheckDigit($upc)){
                    //echo "Match<br/><br/>";
                    if(verifyUPCType($upc)){
                        array_push($upcArray,array('upc' => $upc, 'count' => $var['count'], 'name' => $var['name']));
                    }
                //If they do not match, maybe it's starting with 0 and ommiting the checkdigit, calculate based on last 11
                } else {
                    $checkdigit = calculate_upc_check_digit(substr($upc,1));
                    //echo "No Match, return calculated version UPC which is ".substr($upc,1).$checkdigit."<br/><br/>";
                    $upc = substr($upc,1).$checkdigit;
                    if(verifyUPCType($upc)){
                        array_push($upcArray,array('upc' => $upc, 'count' => $var['count'], 'name' => $var['name']));
                    }
                }
            } elseif (strlen($upc) == 6) {
                //Turn 6 Digit UPC into 12 Digit UPC
                //echo "Expanding UPC to 12 digit<br/>";
                $upc = expandSixUPC($upc);
                if(verifyUPCType($upc)){
                    array_push($upcArray,array('upc' => $upc, 'count' => $var['count'], 'name' => $var['name']));
                }
            }
        }
        return $upcArray;
    }
    
    //Function to verify UPC is not reserved (Special Types, Loyalty Cards, Coupons, etc.)
    function verifyUPCType($upc){
        /*
        *   0,1,6,7,8 - Covers most products
        *   2 - Items sold by weight
        *   3 - Drugs
        *   4 - Reserved, loyalty cards or store coupons
        *   5 - MFR Coupons
        *   9 - MFR Coupons
        */
        $reserved = array(0,1,3,6,7,8);
        return in_array(substr($upc,0,1),$reserved);
    }
    
    //Calculates UPC Check Digit on 11 or 12 digit UPC without one
    function calculate_upc_check_digit($upc_code) {
        $checkDigit = -1; // -1 == failure
        if(strlen($upc_code) == 8){
            $upc = substr($upc_code,0,7);
            $oddPositions = $upc[0] + $upc[2] + $upc[4] + $upc[6];
            $oddPositions *= 3;
            $evenPositions= $upc[1] + $upc[3] + $upc[5];
            $sumEvenOdd = $oddPositions + $evenPositions;
            $checkDigit = (10 - ($sumEvenOdd % 10)) % 10;
        } else {
            $upc = substr($upc_code,0,11);
            // send in a 11 or 12 digit upc code only
            if (strlen($upc) == 11 && strlen($upc_code) <= 12) {
                $oddPositions = $upc[0] + $upc[2] + $upc[4] + $upc[6] + $upc[8] + $upc[10];
                $oddPositions *= 3;
                $evenPositions= $upc[1] + $upc[3] + $upc[5] + $upc[7] + $upc[9];
                $sumEvenOdd = $oddPositions + $evenPositions;
                $checkDigit = (10 - ($sumEvenOdd % 10)) % 10;
            }
        }
        return $checkDigit;
    }
    
    //Checks database for UPC Product Information
    function getUPCInfo($upc){
        
        /* www.semantics3.com Databse */
        $url = 'https://api.semantics3.com/v1/products?q={"upc":"'.$upc.'"}';
        $options = array( 
            'consumer_key' => 'SEM30F917997C4A99F160F9D2809D0C5F33A',
            'consumer_secret' => 'Y2FlYjlkNzA2NWI1N2UyNGViNTI4OTFkNjkzOWExZGM'
        );
        OAuthStore::instance("2Leg", $options, true );
        $request = new OAuthRequester($url, 'GET', "");
        $result = $request->doRequest();
        $response = $result['body'];
        $jsonfile = json_decode($response);
        if($jsonfile->total_results_count > 0){
            $item;
            $item->valid = "true";
            $item->name = $jsonfile->results[0]->name;
            $item->alias = $jsonfile->results[0]->name;
            $item->description = $jsonfile->results[0]->name;
            if(isset($jsonfile->results[0]->price)){
                $item->avg_price = $jsonfile->results[0]->price;
            } else {
                $item->avg_price = '';
            }
            return $item;
        } else {   
            /* Factual Database */
            $url = 'http://api.v3.factual.com/t/products-cpg?filters={"upc":"'.$upc.'"}';
            $options = array( 
                'consumer_key' => 'kkpXOXzCQUo1i0IIJwXr2JQdfeYl2fUHRpoo7F3R',
                'consumer_secret' => 'AD6OaErstwEs2FMA6dRMEdymTqGs8QPF6xKHyLnp'
            );
            OAuthStore::instance("2Leg", $options, true );
            $request = new OAuthRequester($url, 'GET', "");
            $result = $request->doRequest();
            $response = $result['body'];
            $jsonfile = json_decode($response);
            if(count($jsonfile->response->data) > 0) {
                $item;
                $item->valid = "true";
                $item->name = $jsonfile->response->data[0]->product_name;
                $item->alias = $jsonfile->response->data[0]->product_name;
                $item->description = $jsonfile->response->data[0]->product_name;
                if(isset($jsonfile->response->data[0]->avg_price)){
                    $item->avg_price = $jsonfile->response->data[0]->avg_price;
                } else {
                    $item->avg_price = '';
                }
                return $item;
            } else {
                /*UPCDATABASE.ORG Database */
                $key = 'eccf42049c69b644d22bf20c346e73df';
                $json = "http://api.upcdatabase.org/json/$key/$upc";
                $jsonfile = file_get_contents($json);
                return json_decode($jsonfile);
            }
        }
    }
    
    //Turns 6 digit UPC into 12 digit UPC
    function expandSixUPC($upc){
        $lastdigit = getCheckDigit($upc);
        switch($lastdigit){
            case 0:
                $mfr = substr($upc,0,2).'000';
                $prod = '00'.substr($upc,2,3);
                break;
            case 1: case 2:
                $mfr = substr($upc,0,2).$lastdigit.'00';
                $prod = '00'.substr($upc,2,3);
                break;
            case 3:
                $mfr = substr($upc,0,3).'00';
                $prod = '000'.substr($upc,3,2);
                break;
            case 4:
                $mfr = substr($upc,0,4).'0';
                $prod = '0000'.substr($upc,4,1);
                break;
            case 5: case 6: case 7: case 8: case 9:
                $mfr = substr($upc,0,5);
                $prod = '0000'.$lastdigit;
                break;
        }
        echo "Checking parity for $upc<br/>";
        $parity = checkParity($upc); //Array(parity,checkdigit)
        echo "Parity: ";print_r($parity);echo"<br/>";
        $upc = $parity[0].$mfr.$prod.$parity[1];
        echo "Full UPC: $upc<br/>";
        return $upc;
    }
    
    //Returns the parity pattern for 6 digit UPCS
    function checkParity($upc){
        $one = substr($upc,0,1);
        $two = substr($upc,1,1);
        $three = substr($upc,2,1);
        $four = substr($upc,3,1);
        $five = substr($upc,4,1);
        $six = substr($upc,5,1);
        if(isodd($one)){ //O-----
            if(isodd($two)){ //OO----
                if(isodd($three)){ //OOO---
                    //OOOEEE
                    return array(1,0); //(parity,checkdigit);
                } else { //OOE---
                    if(isodd($four)){ //OOEO--
                        //OOEOEE
                        return array(1,1);
                    } else { //OOEE--
                        if(isodd($five)){ //OOEEO-
                            //OOEEOE
                            return array(1,2);
                        } else {
                            //OOEEEO
                            return array(1,3);
                        }
                    }
                }
            } else { //OE----
                if(isodd($three)){ //OEO---
                    if(isodd($four)){ //OEOO--
                         //OEOOEE
                         return array(1,4);
                    } else { //OEOE--
                        if(isodd($five)){ //OEOEO-
                            //OEOEOE
                            return array(1,7);
                        } else { //OEOEE-
                            //OEOEEO
                            return array(1,8);
                        }
                    }
                } else { //OEE---
                    if(isodd($four)) { //OEEO--
                        if(isodd($five)){ //OEEOO-
                            //OEEOOE
                            return array(1,5);
                        } else { //OEEOE-
                            //OEEOEO
                            return array(1,9);
                        }
                    } else { //OEEE--
                        if(isodd($five)){
                            //OEEEOO
                            return array(1,6);
                        }
                    }
                }
            }
        } else { //E-----
            if(isodd($two)) { //EO----
                if(isodd($three)){ //EOO---
                    if(isodd($four)){ //EOOO--
                        //EOOOEE
                        return array(0,6);
                    } else { //EOOE---
                        if(isodd($five)){ //EOOEO-
                           //EOOEOE
                           return array(0,9);
                        } else { //EOOEE-
                            //EOOEEO
                            return array(0,5);
                        }
                    }
                } else { //EOE---
                    if(isodd($four)){ //EOEO--
                        if(isodd($five)) { //EOEOO-
                            //EOEOOE
                            return array(0,8);
                        } else { //EOEOE-
                            //EOEOEO
                            return array(0,7);
                        }
                    } else { //EOEE--
                        //EOEEOO
                        return array(0,4);
                    }
                }
            } else { //EE----
                if(isodd($three)){ //EEO---
                    if(isodd($four)){ //EEOO--
                        if(isodd($five)) { //EEOOO-
                            return array(0,3);
                        } else { //EEOOE-
                            //EEOOEO
                            return array(0,2);
                        }
                    } else { //EEOE--
                        //EEOEOO
                        return array(0,1);
                    }
                } else { //EEE---
                    // EEEOOO
                    return array(0,0);
                }
            }
        }
    }
    
    function isodd($num){
        return (boolean)($num%2);
    }
    //Returns the checkdigit of a passed in UPC
    function getCheckDigit($upc){
        return substr($upc,-1,1);
    }
?>