function uprintf(message, varargin)
    % UPRINTF Print formatted data, allowing trailing overwrites.
    %
    %     UPRINTF(formatSpec, A1, ..., An) applies the formatSpec to all
    %     elements of array A and any additional array arguments in column
    %     order, and prints the results
    %
    %     UPRINTF is the same as fprintf except that it allows trailing
    %     characters to be overwritten to provide status information.
    %
    %     formatSpec is a string that describes the format of the output fields,
    %     and is described in fprintf or sprintf help documentation.
    %
    %     If formatSpec contains the bar character '|', it indicates the
    %     location at which the trailing text can be overwritten in subsequent
    %     calls to uprintf.
    %
    %     If the first character in formatSpec is the bar character '|', the
    %     following text is used to overwrite data previously marked by a call
    %     to uprintf. However, calling UPRINTF('|') sets the deletion point if
    %     it is at the beginning of a line.
    %
    %     Examples
    %        UPRINTF('Items processed: |1')    	% 'Items processed: 1'
    %        UPRINTF('|2')                     	% 'Items processed: 2'
    %        UPRINTF('\n')                     	%
    %        UPRINTF('Next name: |%s', 'Colin')	% 'Next name: Colin'
    %        UPRINTF('|Jamie')                 	% 'Next name: Jamie'
    %        UPRINTF('\n')                     	%
    %        UPRINTF('|')                      	%
    %        UPRINTF('|%3d%% Complete', 50)    	% ' 50% Complete'
    %        UPRINTF('|%3d%% Complete', 100)   	% '100% Complete'
    %
    %     See also fprintf, sprintf, sscanf, num2str, int2str, char.
    %
    % Frazer McLean <frazergmclean@gmail.com>

    %% Design Rationale
    %
    % Global variable(s) are used to store the state, allowing subsequent calls
    % to uprintf to have access to information required to produce desired
    % result. Ideally a class would be used but then there's the problem of
    % instantiating.
    %
    % At least in Matlab, global variables are only accessible where they are
    % marked explicitly as global, so the workspace isn't affected.
    global UPRINTF_DELETE_NUM UPRINTF_LOG_FILE UPRINTF_LOG_FILE_ID UPRINTF_PART_MESSAGE
    if strcmpi(message, '-logfile')
        if ~isempty(UPRINTF_LOG_FILE_ID) && nargin == 1
            fprintf(UPRINTF_LOG_FILE_ID, '\n');
            fclose(UPRINTF_LOG_FILE_ID);
            UPRINTF_LOG_FILE = '';
            return
        end
        narginchk(2,2)
        UPRINTF_LOG_FILE = varargin{1};
        if ~isempty(UPRINTF_LOG_FILE)
            if ~isempty(UPRINTF_LOG_FILE_ID)
                fprintf(UPRINTF_LOG_FILE_ID, '\n');
                fclose(UPRINTF_LOG_FILE_ID);
            end
            UPRINTF_LOG_FILE_ID = fopen(UPRINTF_LOG_FILE, 'at');
            fprintf(UPRINTF_LOG_FILE_ID, '[LOG %s]\n', datestr(now));
        else
            fprintf(UPRINTF_LOG_FILE_ID, '\n');
            fclose(UPRINTF_LOG_FILE_ID);
        end
        return
    end
    bar_position = strfind(sprintf(message, varargin{:}), '|');
    if ~isempty(bar_position)
        if bar_position == 1 && length(message) > 1
            % If bar is the first character, then the string is being updated.
            fprintf(repmat('\b', 1, UPRINTF_DELETE_NUM))
            message = message(2:end);
            message = sprintf(message, varargin{:});
            fprintf('%s', message)
            UPRINTF_DELETE_NUM = length(message);
            logfile([UPRINTF_PART_MESSAGE message])
            return
        else
            message = sprintf(message, varargin{:});
            message = strrep(message, '|', '');
            UPRINTF_PART_MESSAGE = message(1:bar_position-1);
            UPRINTF_DELETE_NUM = length(message) - bar_position + 1;
            if length(message) == 0
                return
            end
            fprintf('%s', message)
            logfile(message)
        end
    else
        UPRINTF_PART_MESSAGE = '';
        message = sprintf(message, varargin{:});
        fprintf('%s', message)
        logfile(message)
    end
end

function logfile(message)
    global UPRINTF_LOG_FILE UPRINTF_LOG_FILE_ID
    if ~isempty(UPRINTF_LOG_FILE)
        newline = '';
        if ~strcmp(message(end), sprintf('\n'))
            newline = '\n';
        end
        fprintf(UPRINTF_LOG_FILE_ID, ['%s' newline], message);
    end
end
% uprintf('Items processed: |1')	% 'Items processed: 1'
% uprintf('|2\n')               	% 'Items processed: 2'

% uprintf('Next name: |%s', 'Colin')	% 'Next name: Colin'
% uprintf('|Jamie\n')               	% 'Next name: Jamie'

% uprintf('|')                     	%
% uprintf('|%3d%% Complete\n', 50) 	% ' 50% Complete'
% uprintf('|%3d%% Complete\n', 100)	% '100% Complete'
