//////////////////////////////////////////////
// project:key debounce
// author :charleswang
// module :key_debounce
// version:1.0
//////////////////////////////////////////////
module key_debounce
#(
parameter IDLE = 0,
parameter NEG_DETECT=1,
parameter KEY_DOWN = 2,
parameter POS_DETECT = 3,
parameter KEY_UP = 4,
parameter TIMER_20MS = 9//99_999 //10的6次方个20ns/clk
)

(
input key_in,
input clk,
input rst_n,

output  reg led

);
reg [1:0]key_in_r;
wire flag_neg_w;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		key_in_r <= 0;
	end
	else begin
		key_in_r <= {key_in_r[0],key_in};
	end
end
assign flag_neg_w = (key_in_r[1] & !key_in_r[0]) ? 1'b1:1'b0; //检测按键下降沿
assign flag_pos_w = (key_in_r[0] & !key_in_r[1]) ? 1'b1:1'b0;//检测按键上升沿
reg [2:0]state_r;
reg timer_start_r;
reg [19:0]timer_cnt_r;
reg flag_key_down_r;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		state_r <= IDLE;
		timer_start_r <= 0;
		flag_key_down_r <= 0;
	end
	else begin
		case(state_r) 
		IDLE: begin     //空闲的状态
			flag_key_down_r <= 0;
			if(flag_neg_w)begin
				state_r <= NEG_DETECT;
				timer_start_r <= 1;
			end
			else begin
				state_r <= IDLE;
				timer_start_r <= 0;
			end
		end
		NEG_DETECT: begin
			
			if(timer_cnt_r == TIMER_20MS)begin
				state_r <= KEY_DOWN;
				timer_start_r <= 0;
			end
			else if(flag_pos_w)begin
				state_r <= IDLE;
				timer_start_r <= 0;
			end
			else begin
				state_r <= NEG_DETECT;
				//timer_start_r <= 1;
			end
		end
		KEY_DOWN: begin
			flag_key_down_r <= 0;
			if(flag_pos_w)begin
				state_r <= POS_DETECT;
				timer_start_r <= 1;
			end
			else begin
				state_r <= KEY_DOWN;
				timer_start_r <= 0;
			end
		end
		POS_DETECT:begin
			if(timer_cnt_r == TIMER_20MS)begin
				state_r <= KEY_UP;
				timer_start_r <=0;
				flag_key_down_r <= 1;
			end
			else if(flag_neg_w )begin
				state_r <= KEY_DOWN;
				timer_start_r <= 0;
			end
			else begin
				state_r <= POS_DETECT;
				//timer_start_r <= 1;
			end
		end
		KEY_UP:begin
			flag_key_down_r <= 0;
			if(flag_neg_w)begin
				state_r <= NEG_DETECT;
				timer_start_r <= 1;
			end
			else begin
				state_r <= KEY_UP;
				timer_start_r <= 0;
			end
		end
		default: state_r <= IDLE;
		endcase
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		timer_cnt_r <= 0;
	end
	else if(timer_start_r)begin
		timer_cnt_r <= timer_cnt_r + 1;
	end
	else begin 
		timer_cnt_r <= 0;
	end
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		led <= 1;
	end
	else begin
		if(flag_key_down_r)begin	
			led <= ~led;
		end
		else begin
			led <= led;
		end
	end
end
endmodule

