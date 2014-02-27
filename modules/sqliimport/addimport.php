<?php

/**
 * SQLi Import add immediate import view
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
$importINI = eZINI::instance( 'sqliimport.ini' );
$http = eZHTTPTool::instance();

$importHandler = $Module->hasActionParameter( 'ImportHandler' ) ? $Module->actionParameter( 'ImportHandler' ) : false;
$importOptions = $Module->hasActionParameter( 'ImportOptions' ) ? $Module->actionParameter( 'ImportOptions' ) : array();
if ( $http->hasPostVariable( 'FileOptions' ) ) {
	foreach ( $http->postVariable( 'FileOptions' ) as $fileOption ) {
		if ( eZHTTPFile::canFetch( 'UploadFile_' . $fileOption ) ) {
			$binaryFile = eZHTTPFile::fetch( 'UploadFile_' . $fileOption );
			$suffix = pathinfo( $binaryFile->attribute( 'original_filename' ), PATHINFO_EXTENSION );
			$binaryFile->store( 'sqliimport', $suffix );
			$importOptions[$fileOption] = $binaryFile->attribute( 'filename' );
			//eZDebug::writeDebug( "set $fileOption", "sqliimport::addimport" );
		}
	}
}
try {
	$userLimitations = SQLIImportUtils::getSimplifiedUserAccess( 'sqliimport', 'manageimports' );
	$simplifiedLimitations = $userLimitations['simplifiedLimitations'];

	if ( $Module->isCurrentAction( 'RequestImport' ) ) {
		// Check if user has access to handler alteration
		$aLimitation = array( 'SQLIImport_Type' => $Module->actionParameter( 'ImportHandler' ) );
		$hasAccess = SQLIImportUtils::hasAccessToLimitation( $Module->currentModule(), 'manageimports', $aLimitation );
		if ( !$hasAccess ) {
			return $Module->handleError( eZError::KERNEL_ACCESS_DENIED, 'kernel' );
		}
		foreach ( $importOptions as $index => $value ) {
			if ( empty( $value ) ) {
				unset( $importOptions[$index] );
			}
		}

		$pendingImport = new SQLIImportItem( array(
			'handler' => $Module->actionParameter( 'ImportHandler' ),
			'user_id' => eZUser::currentUserID()
				) );
		if ( $importOptions ) {
			$pendingImport->setAttribute( 'options', new SQLIImportHandlerOptions( $importOptions ) );
		}
		$pendingImport->store();
		$Module->redirectToView( 'list' );
	} elseif ( $Module->isCurrentAction( 'SQIImportSelectNode' ) ) {
		$selectedNodeIDArray = eZContentBrowse::result( 'SQIImportSelectNode' );
		$nodeID = current( $selectedNodeIDArray );
		if ( is_numeric( $nodeID ) ) {
			$importHandler = $http->variable( 'handler' );
			//eZDebug::writeDebug( "Browse::result ". $http->variable( 'import_options' ), "sqliimport::addimport" );
			parse_str( $http->variable( 'import_options' ), $importOptions );
			$importOptions[$http->variable( 'option' )] = $nodeID;
		}
	} elseif ( $Module->isCurrentAction( 'Browse' ) ) {
		$handler = $http->postVariable( 'ImportHandler' );
		$browseArray = $http->postVariable( 'BrowseButton' );
		if ( key( $browseArray ) ) {
			$importOptions = array_merge( $http->postVariable( 'ImportOptions' ), $importOptions );
			//eZDebug::writeDebug( "Browse ".http_build_query( $importOptions ), "sqliimport::addimport" );
			eZContentBrowse::browse( array( 'action_name' => 'SQIImportSelectNode',
				'description_template' => false,
				'persistent_data' => array(
					'handler' => $handler,
					'option' => key( $browseArray ),
					'import_options' => http_build_query( $importOptions ) ),
				'from_page' => "/sqliimport/addimport" ), $Module );
			return;
		}
	}

	$importHandlers = $importINI->variable( 'ImportSettings', 'AvailableSourceHandlers' );
	$aValidHandlers = array();
	// Check if import handlers are enabled
	foreach ( $importHandlers as $handler ) {
		$handlerSection = $handler . '-HandlerSettings';
		if ( $importINI->variable( $handlerSection, 'Enabled' ) === 'true' ) {
			$handlerName = $importINI->hasVariable( $handlerSection, 'Name' ) ? $importINI->variable( $handlerSection, 'Name' ) : $handler;
			/*
			 * Policy limitations check.
			 * User has access to handler if it appears in $simplifiedLimitations['SQLIImport_Type']
			 * or if $simplifiedLimitations['SQLIImport_Type'] is not set (no limitations)
			 */
			if ( ( isset( $simplifiedLimitations['SQLIImport_Type'] ) && in_array( $handler, $simplifiedLimitations['SQLIImport_Type'] ) ) || !isset( $simplifiedLimitations['SQLIImport_Type'] ) ) {
				$aValidHandlers[$handlerName] = $handler;
			}
		}
	}

	$tpl->setVariable( 'current_import_handler', $importHandler );
	$tpl->setVariable( 'import_options', $importOptions );
	$tpl->setVariable( 'importHandlers', $aValidHandlers );
} catch ( Exception $e ) {
	$errMsg = $e->getMessage();
	OWScriptLogger::writeError( $errMsg, 'addimport' );
	$tpl->setVariable( 'error_message', $errMsg );
}

$Result['path'] = array(
	array(
		'url' => false,
		'text' => SQLIImportUtils::translate( 'extension/sqliimport', 'Request a new immediate import' )
	)
);
$Result['left_menu'] = 'design:sqliimport/parts/leftmenu.tpl';
$Result['content'] = $tpl->fetch( 'design:sqliimport/addimport.tpl' );
