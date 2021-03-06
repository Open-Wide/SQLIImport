<?php

/**
 * SIGTERM Handler.
 * This piece of code allows to catch system signals such as SIGTERM, SIGINT or SIGKILL
 * Will cleanup the running import by interrupting the process safely
 * Needs {@link http://php.net/pcntl PCNTL} to work properly (doesn't work on Windows)
 * @uses PCNTL
 * @copyright Copyright (C) 2010 - SQLi Agency. All rights reserved
 * @licence http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 * @author Jerome Vieilledent
 * @version @@@VERSION@@@
 * @package sqliimport
 */
$isPcntl = function_exists( 'pcntl_signal' );
if( $isPcntl )
{
    declare( ticks = 1 );

    function SQLIImportSignalHandler( $signo )
    {
        if( SQLIImportToken::importIsRunning() )
        {
            // Note : SIGKILL cannot be caught
            // So try to always send a SIGINT (kill -2) or SIGTERM (kill -15) to request interruption
            switch( $signo )
            {
                case SIGTERM:
                case SIGINT:
                    $db = eZDB::instance();
                    $db->rollback();
                    OWScriptLogger::logNotice( 'Caught SIGTERM while importing. Demanding import interruption (might take a little while)', 'sigtermhandler' );
                    $factory = SQLIImportFactory::instance();
                    $currentItem = $factory->getCurrentImportItem();
                    $currentItem->setAttribute( 'status', SQLIImportItem::STATUS_INTERRUPTED );
                    $currentItem->store();
                    SQLIImportToken::cleanAll();
                    break;
            }
        }
    }

    if( !function_exists( 'OWScriptLoggerSignalHandler' ) )
    {
        pcntl_signal( SIGTERM, 'SQLIImportSignalHandler' );
        pcntl_signal( SIGINT, 'SQLIImportSignalHandler' );
    }
}
