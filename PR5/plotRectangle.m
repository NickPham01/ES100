function [x,y] = plotRectangle(x_len, y_len, lines, corners)
    hold on

    x = -x_len/2;
    y = -y_len/2;
    
    if lines > 0
        rectangle('Position', [x, y, x_len, y_len]);
    end
    if corners > 0
        X_corners = [x, x, x+x_len, x+x_len];
        Y_corners = [y, y+y_len, y, y+y_len];
        scatter(X_corners, Y_corners);
    end
    hold off
        
end