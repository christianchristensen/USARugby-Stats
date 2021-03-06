<?php
include_once './include_mini.php';

//verify we can edit.  1 is usarugby only.  Redirect if not?
if (editCheck(1)) {

    $comp_id = $_GET['id'];
?>
<div id="wrapper" class="container-fluid">
  <div class="row-fluid">
    <form name='addteam' id='addteam' method='POST' action=''>
      <div class="alert error alert-error" id="form-validation-error">
        <button type="button" class="close" data-dismiss="alert">×</button>
        <div class="error-message"></div>
      </div>
      <div class="row-fluid">

        <div id="team-wrapper">
          <div class="control-group">
            <div class="controls">
              <select data-placeholder='Team' name='team' id='team' class="required input-medium chzn-select" style="width: 100%;">
                  <option value=''></option>
                  <?php
                    //give a list of every team to choose from
                    $query = "SELECT team_id FROM ct_pairs WHERE comp_id=$comp_id";
                    $result = mysql_query($query);
                    while ($row=mysql_fetch_assoc($result)) {
                        $andsort = $andsort."AND id != '{$row['team_id']}' ";
                    }

                    $query = "SELECT * FROM `teams` WHERE 1 $andsort AND status = 'show' ORDER BY name ASC";
                    $result = mysql_query($query);
                    while ($row=mysql_fetch_assoc($result)) {
                        $type = ucfirst($row['type']);
                        echo "<option value='{$row['id']}'>{$row['name']} - {$row['description']} - {$type}</option>";
                    }
                  ?>
              </select>
            </div>
            <br />
            <div class="controls">
              <select data-placeholder='Division' name='division' id='division' class="input-medium chzn-select" style="width: 100%;">
                  <option value=''></option>
                  <?php
                    $divisions = $db->getDivisions($comp_id);
                    foreach ($divisions as $id => $division) {
                        echo "<option value='{$id}'>{$division}</option>";
                    }
                  ?>
              </select>
            </div>
          </div>
        </div>
      </div>
      <div class="row-fluid">
        <div id="submit-wrapper" class="span1">
          <div class="control-group">
            <label for="submit" id="submit_label" class="control-label">&nbsp;</label>
            <div class="controls">
              <input type='hidden' name='trefresh' id='trefresh' value=<?php echo '"' .  "comp_teams.php?id=$comp_id" . '"'; ?>>
              <input type='hidden' name='lrefresh' id='lrefresh' value=<?php echo '"' . "add_team.php?id=$comp_id" . '"'; ?>>
              <input type='hidden' name='comp_id' id='comp_id' value=<?php echo '"' . $comp_id . '"'; ?>>
              <input type='submit' name='submit' class='button btn btn-primary' id='add_team' value='Add Team'>
            </div>
          </div>
        </div>

      </div>
    </form>
  </div>
</div>
<script type='text/javascript'>$('.error').not(function(index){return $(this).hasClass('control-group');}).hide();</script>
<?php
}
?>