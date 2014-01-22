<?php

/**
 * SQLi Import remove scheduled import view
 * @copyright Copyright (C) 2010 - SQLi Agency. All rights reserved
 * @licence http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 * @author Jerome Vieilledent
 * @version @@@VERSION@@@
 * @package sqliimport
 */
OWScriptLogger::startLog( 'sqliimport_module' );
OWScriptLogger::setAllowedDatabaseDebugLevel( 'none' );

$Module = $Params['Module'];
$Result = array();
$tpl = SQLIImportUtils::templateInit();
$db = eZDB::instance();

try {
	$user = eZUser::currentUser();
	$userID = $user->attribute( 'contentobject_id' );
	$userLogin = $user->attribute( 'login' );
	$importID = $Params['ImportID'];

	$db->begin();
	$import = SQLIScheduledImport::fetch( $importID );
	if ( !$import instanceof SQLIScheduledImport ) {
		throw new SQLIImportBaseException( SQLIImportUtils::translate( 'extension/sqliimport/error', "No import item found with ID #%importID", null, array(
			'%importID' => $importID ) ) );
	}

	// Check if user has access to handler alteration
	$aLimitation = array( 'SQLIImport_Type' => $import->attribute( 'handler' ) );
	$hasAccess = SQLIImportUtils::hasAccessToLimitation( $Module->currentModule(), 'manageimports', $aLimitation );
	if ( $hasAccess ) {
		OWScriptLogger::logNotice( 'User "' . $userLogin . '" (#' . $userID . ') removed scheduled import #' . $importID . ' on ' . date( 'Y-m-d H:i' ), 'removescheduled' );
		$import->remove();
		$db->commit();

		$Module->redirectToView( 'scheduledlist' );
	} else {
		$db->rollback();
		return $Module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );
	}
} catch ( Exception $e ) {
	$errMsg = $e->getMessage();
	OWScriptLogger::writeError( $errMsg, 'removescheduled' );
	$tpl->setVariable( 'error_message', $errMsg );

	$Result['path'] = array(
		array(
			'url' => false,
			'text' => SQLIImportUtils::translate( 'extension/sqliimport/error', 'Error' )
		)
	);
	$Result['left_menu'] = 'design:sqliimport/parts/leftmenu.tpl';
	$Result['content'] = $tpl->fetch( 'design:sqliimport/altererror.tpl' );
}

