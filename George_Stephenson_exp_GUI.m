function George_Stephenson_exp_GUI
% Create a GUI window
f = figure('Name', 'George Stephenson Experiment', 'NumberTitle', 'off');
% Create a panel for user input;
% Create a text box to prompt the user to enter the starting number of cells
start_cells_prompt = uicontrol('Parent', f, 'Style', 'text', 'String', 'Starting Cell Count:', 'Position', [20 370 100 20]);
% Create an edit box for the user to enter the starting number of cells
start_cells_input = uicontrol('Parent', f, 'Style', 'edit', 'Position', [20 350 100 20]);
% Create a text box to prompt the user to enter the growth rate
growth_rate_prompt = uicontrol('Parent', f, 'Style', 'text', 'String', 'Growth Rate:', 'Position', [20 320 100 20]);
% Create an edit box for the user to enter the growth rate
growth_rate_input = uicontrol('Parent', f, 'Style', 'edit', 'Position', [20 300 100 20]);
% Create a text box to prompt the user to enter the time step
time_step_prompt = uicontrol('Parent', f, 'Style', 'text', 'String', 'Time Step:', 'Position', [20 270 100 20]);
% Create an edit box for the user to enter the time step
time_step_input = uicontrol('Parent', f, 'Style', 'edit', 'Position', [20 250 100 20]);
% Create a text box to prompt the user to enter the percent noise
noise_percent_prompt = uicontrol('Parent', f, 'Style', 'text', 'String', 'Percent Noise:', 'Position', [20 215 100 20]);
% Create an edit box for the user to enter the percent noise
noise_percent_input = uicontrol('Parent', f, 'Style', 'edit', 'Position', [20 200 100 20]);
% Create a push button to run the experiment
run_button = uicontrol('Parent', f, 'Style', 'pushbutton', 'String', 'Run Experiment', 'Position', [20 160 100 20], 'Callback', @run_George_Stephenson_exp);
% Create a callback function to run the experiment
    function run_George_Stephenson_exp(~, ~)
        % Retrieve the user inputs
        starting_number = str2double(get(start_cells_input, 'String'));
        growth_rate = str2double(get(growth_rate_input, 'String'));
        time_step = str2double(get(time_step_input, 'String'));
        noise_percent = str2double(get(noise_percent_input, 'String'));
        % Determine the amount of time it takes to acheive 6 doublings
        dt_6 = 6*(log(2)/.2);
        % Display the amount of time it takes to acheive 6 doublings
        disp('Time required to acheive six doublings:')
        disp(dt_6)
        % Set up the data for cell count v time for graphical analysis
        domain = 0:time_step:dt_6;
        count_cells = zeros(1,length(domain));
        count_cells(1,1) = starting_number;
        for i = 2:length(domain)
            count_cells(1,i) = count_cells(1, i-1) * (1+(growth_rate/100)*time_step);
        end
        % Plot the cell count with a title, and legend indicating the starting number of cells and the growth rate
        subplot(2,2,1);
        plot(domain,count_cells);
        title('Cell Count v Time')
        xlabel('Time')
        ylabel('Number of Cells')
        legendText = sprintf('Initial cell count: %d\nGrowth rate: %d', starting_number, growth_rate);
        legend(legendText);
        % Generate an array of starting_numbers from 1 to 10000 and plot how the starting number of cells affects the final number of cells after nine doubling times
        % Generate an array of starting numbers from 1 to 10000
        start_numbers = 1:10000;
        % Initialize a matrix to store the final cell count for each starting number
        final_cell_counts = zeros(length(start_numbers),1);
        % Calculate the amount of time it takes to achieve 9 doublings
        dt_9 = 9*(log(2)/.2);
        disp('Time Required to Acheive 9 Doublings:')
        disp(dt_9)
        % Define the domain
        domain = 0:time_step:dt_9;
        % Iterate through each starting number
        for i = 1:length(start_numbers)
            % Set the starting number of cells
            starting_number = start_numbers(i);
            % Create an array to store the cell count
            count_cells = zeros(1, length(domain));
            % Set the initial cell count
            count_cells(1,1) = starting_number;
            % Iterate through each time step
            for j = 2:length(domain)
                % Calculate the cell count
                count_cells(1,j) = count_cells(1, j-1) * (1+(growth_rate/100)*time_step);
            end
            % Store the final cell count
            final_cell_counts(i) = count_cells(1,length(domain));
        end
        % Plot the final cell count versus the starting number
        subplot(2,2,2);
        plot(start_numbers, final_cell_counts);
        title('Final Cell Count v Starting Number')
        xlabel('Starting Number')
        ylabel('Final Cell Count')
        % Create a subfunction that generates an exponential growth curve from the
        % analytical solution of y(t)=y(0)exp(x/100)t.
        function analytical_data = analytical_sol(starting_number, growth_rate, time_step, dt_9)
            % Create an array to store the cell count
            analytical_data = zeros(1, length(domain));
            % Set the initial cell count
            analytical_data(1,1) = starting_number;
            % Iterate through each time step
            for j = 2:length(domain)
                % Calculate the cell count
                analytical_data(1,j) = analytical_data(1, j-1) * exp((growth_rate/100)*time_step);
            end
        end
        % Plot on Figure 3 an overlay of your noisy simulated data and the
        % modeled data (as a line).
        % Generate the analytical data
        analytical_data = analytical_sol(starting_number, growth_rate, time_step, dt_9);
        % Add noise to the simulated data
        noisy_data = add_noise(count_cells, noise_percent);
        % Plot the overlaid data
        subplot(2,2,3);
        plot(domain, analytical_data, 'r', domain, noisy_data(1,:), 'g')
        title('Noisy Data v Modeled Data')
        xlabel('Time')
        ylabel('Number of Cells')
        legend('Analytical Data', 'Noisy Data');
        % Generate an array of doubling times from 1 to 9
        doubling_times = 1:9;
        % Initialize a matrix to store the final cell count for each starting number
        final_cell_counts = zeros(length(start_numbers),length(doubling_times));
        % Iterate through each starting number
        for i = 1:length(start_numbers)
            % Set the starting number of cells
            starting_number = start_numbers(i);
            % Iterate through each doubling time
            for j = 1:length(doubling_times)
                % Calculate the amount of time it takes to achieve each doubling time
                dt = doubling_times(j)*(log(2)/.2);
                % Define the domain
                domain = 0:time_step:dt;
                % Create an array to store the cell count
                count_cells = zeros(1, length(domain));
                % Set the initial cell count
                count_cells(1,1) = starting_number;
                % Iterate through each time step
                for k = 2:length(domain)
                    % Calculate the cell count
                    count_cells(1,k) = count_cells(1, k-1) * (1+(growth_rate/100)*time_step);
                end
                % Store the final cell count
                final_cell_counts(i,j) = count_cells(1,length(domain));
            end
        end
        % Calculate the error
        error_pi=sum((noisy_data-analytical_data).^2);
        error=sqrt(error_pi);
        disp('Error Rate:')
        disp(mode(error))
        % Plot the final cell count versus the starting number and number of doublings
        subplot(2,2,4);
        surf(doubling_times, start_numbers, final_cell_counts, 'EdgeColor', 'none');
        title('Final Cell Count v Starting Number and Doublings');
        xlabel('Doublings');
        ylabel('Starting Number');
        zlabel('Final Cell Count');
    end
end
% Create a subfunction to add noise to the data

function noisy_data = add_noise(data, noise_percent)
% Generate random noise
noise = (noise_percent/100)*(rand(size(data))-.5).*data;

% Check if noisy data will be negative
if min(noise + data) < 0
    % Set growth rate = 0
    growth_rate = 0;
    % Update noisy plot
    noisy_data = growth_rate;
else
    % Add the noise to the data
    noisy_data = data + noise;
end
end

