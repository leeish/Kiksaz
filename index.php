<?php require('functions.php'); ?>
<!DOCTYPE>
<html>
<head>
<link href="/css/styles.css" type="text/css" rel="stylesheet" media="screen" />
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=yes">
<meta name="description" content="">
<meta name="keywords" content="" />
<title>Title</title>
</head>
<body>
    <form id="Input" method="POST">
        <textarea name="rec"></textarea>
        <input type="submit" name="submit" value="Submit" />
    </form>
    <?php if (isset($_POST['submit']) && $_POST['submit'] == 'Submit') { ?>
        <?php echo $found; ?> UPCS Found on receipt:
        <ul>
        <?php foreach($items as $item){ ?>
              
            <?php if($item->name == 'Unknown Item'){ ?>
                <li>Unknown Item Found: <?php echo $item->upc['upc']; ?>
                    <ul>
                        <li>Description: <?php echo $item->upc['name']; ?></li>
                        <li>Qty: <?php echo $item->upc['count']; ?></li>
                    </ul>
                </li>   
            <?php } else { ?>
                <li style="margin: 10px 0;"><?php echo $item->name." : ".$item->upc; ?>
                    <ul>
                        <li><?php echo $item->description; ?></li>
                        <li>Avg Price: <?php echo $item->avg_price; ?></li>
                        <li>Qty: <?php echo $item->count; ?></li>
                    </ul>
                </li>
            <?php } ?>
                
        <? } ?>
        </ul>
    <?php } ?>
</body>
</html>