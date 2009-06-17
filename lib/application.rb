require 'hotcocoa'

# Replace the following code with your own hotcocoa code

class Application

  include HotCocoa   
  
  def draw_header
    layout_view(:frame => [0, 0, 0, 40], :mode => :horizontal, :spacing => 0, :margin => 0, :layout => {:start => false, :expand => [:width]}) do |horiz|
      horiz << label(:text => "Feed", :layout => {:align => :center})
      horiz << @feed_field = text_field(:layout => {:expand => [:width], :align => :center})
      horiz << button(:title => 'go', :layout => {:align => :center}) do |b|
        b.on_action { load_feed }
      end
    end
  end
  
  def draw_table2     
    layout_view(:frame => [0, 0, 0, 0], :mode => :horizontal, :spacing => 0, :margin => 0, :padding => 0, :layout => {:expand => [:width,:height]}) do |horiz| 
      horiz << draw_table1
    end
  end
  
  def draw_table1       
    scroll_view(:layout => {:spacing => 0, :margin => 0, :start => false, :expand => [:width, :height]}) do |scroll|
      scroll.setAutohidesScrollers(true)
      scroll << table_view(:columns => @columns, :data => @data) do |table|
         table.setUsesAlternatingRowBackgroundColors(true)
         table.setGridStyleMask(NSTableViewSolidHorizontalGridLineMask)
      end
    end
  end    
  
  
  def update_window_geometry
    frame = @main_window.frame
    NSLog "x=#{frame.origin.x}, y=#{frame.origin.y}, width=#{frame.size.width}, height=#{frame.size.height}" 
    
    @tables_view.frame =  [0,0, frame.size.width-15, frame.size.height-80] 
  end
  
  def start            
    
    @columns = [column(:id => :name, :title => 'Name', :width => 20),
                column(:id => :age, :title => 'Age', :width => 20),
                column(:id => :sex, :title => 'Sex', :width => 20)]
                                     
    @data = [ { :name => 'Betty Sue', :age => 29, :sex => 'F' },
              { :name => 'Brandon Oberon', :age => 0.005, :sex => 'M' },
              { :name => 'Sally Joe', :age => 48, :sex => 'F'},
              { :name => 'Betty Sue', :age => 29, :sex => 'F' },
              { :name => 'Brandon Oberon', :age => 0.005, :sex => 'M' },
              { :name => 'Sally Joe', :age => 48, :sex => 'F'},
              { :name => 'Betty Sue', :age => 29, :sex => 'F' },  
              { :name => 'Brandon Oberon', :age => 0.005, :sex => 'M' },
              { :name => 'Sally Joe', :age => 48, :sex => 'F'}]
    
                         
    
    application(:name => "QueryExec") do |app|
      app.delegate = self
      @main_window = window(:size => [640, 480], :center => true, :title => "QueryExec", :view => :nolayout) do |win|
        win.will_close { exit }
        win.view = layout_view(:layout => {:expand => [:width, :height]}, :spacing => 0, :margin => 0) do |vert|
          vert << draw_header
          #vert << draw_table1 
          
          #vert.on_notification { |notification| NSLog("Received notification of #{notification.name} on vert")}
 
 
          vert << scroll_view(:layout => {:spacing => 0, :margin => 0, :padding => 0, :start => false, :expand => [:width, :height]}) do |scroll|   
            scroll << @tables_view = layout_view(:frame => [0, 0, 640, 480], :spacing => 0, :margin => 0, :padding => 0, :layout => {:start => false, :expand => [:width, :height]}) do |horiz|
              horiz << draw_table1
              horiz << draw_table1
              horiz << draw_table1 
            end
          end
        end  
        
        win.did_resize { update_window_geometry } 
                          
        win.view.on_notification { |notification| 
          NSLog("Received notification of #{notification.name} on win")
          #@tables_view.frame =  [0,0, 640, 480]        
        }
      end
    end
    
    update_window_geometry    

    
    return
    application :name => "Queryexec" do |app|
      app.delegate = self
      window :frame => [100, 100, 500, 500], :title => "Queryexec" do |win|
        win << label(:text => "Hello from HotCocoa", :layout => {:start => false})  
        
        win << layout_view(:frame => [0,0,0,40],:mode => :horizontal,
                             :layout => {:spacing => 0, :margin => 0, :start => false, :expand => [:width]}) do |horiz|          
           horiz << @feed_field = text_field(:layout => {:expand => [:width]})
           horiz << button(:title => 'Execute', :layout => {:align => :center}) do |b|
             b.on_action { on_button_click }
           end 
           
           horiz.on_notification do |notification|
             NSLog "Received notification of #{notification.name} on horiz"
           end
           
         end
         
         
         #win << scroll_view(:layout => {:expand => [:width, :height], :spacing => 0, :margin => 0}) do |scroll|                     
            win << layout_view(:frame => [0,0,400,600], :layout => {:expand => [:width, :height], :spacing => 0, :margin => 0}) do |layout| 
              layout.auto_resize=true
              @tables = layout 
              layout.on_notification do |notification|
                NSLog "Received notification of #{notification.name} on tables layout"
              end
            end   
            # scroll.on_notification do |notification|
            #               NSLog "Received notification of #{notification.name} on scroll"
            #             end      
         #end
        
        win.will_close { exit }     
        win.on_notification :named => 'NSWindowDidResizeNotification' do |notification|
           NSLog "A window resized!"
        end  
        win.on_notification do |notification|
           NSLog "Received notification of #{notification.name} on win"
         end
      end
    end      
    
    5.times do
       on_button_click
     end   
        
    return   
    

    
    NSLog "evo me"
    application(:name => "QueryExec") do |app|
      app.delegate = self
      @window = window(:size => [640, 480], :center => true, :title => "QueryExec") do |win|   
        
        
        
        win.will_close { exit }                 
        
         win.on_notification do |notification|
           NSLog "Received notification of #{notification.name} on win"
         end

        win << layout_view(:layout => {:expand => [:width, :height],
                                           :spacing => 0, :margin => 0}) do |vert|
                                             
                                             
                                             vert.on_notification do |notification|
                                               NSLog "Received notification of #{notification.name} on vert"
                                             end                                   
                                             
          @vert = vert
          vert << layout_view(:frame => [0,0,0,40],:mode => :horizontal, :border => :line,
                              :layout => {:spacing => 0, :margin => 0,
                                          :start => false, :expand => [:width]}) do |horiz|
            #horiz << label(:text => "Feed", :layout => {:align => :center})
            horiz << @feed_field = text_field(:layout => {:expand => [:width]})
            horiz << button(:title => 'Execute', :layout => {:align => :center}) do |b|
              b.on_action { on_button_click }
            end
          end            
          
          
          # vert << layout_view(:layout => {:expand => [:width, :height], :spacing => 0, :margin => 0}) do |layout| 
          #   @tables = layout  
          #   layout.on_notification do |notification|
          #     NSLog "Received notification of #{notification.name} on my window"
          #   end
          # end

          
          # vert << scroll_view(:frame => [0,0,600,400], :layout => {:expand => [:width, :height]}) do |s|
          #   
          #   # s << view(:frame => [0,0,0,400], :layout => {:spacing => 0, :margin => 0, :expand => [:width, :height]}) do |tables|
          #   #   @tables = tables     
          #   #   tables << text_field(:layout => {:expand => [:width]})                                           
          #   # end
          #   10.times do |i|                                                                                               
          #     s << text_field(:text => "your text here #{i}", :layout => {:start => false, :expand => [:width]}, :frame => [10 * i, 10 * i, 10 * i, 10 * i]) 
          #   end
          #   # s << table_view(:columns => @columns, :data => @data) do |table|
          #   #          table.setUsesAlternatingRowBackgroundColors(true)
          #   #          table.setGridStyleMask(NSTableViewSolidHorizontalGridLineMask)                             
          #   #       end                                            
          # end   
            

          vert << scroll_view(:layout => {:expand => [:width, :height], :spacing => 0, :margin => 0}) do |scroll|                     
            scroll.auto_resize=true  
            scroll << layout_view(:frame => [0,0,400,600], :layout => {:expand => [:width, :height], :spacing => 0, :margin => 0}) do |layout| 
              layout.auto_resize=true
              @tables = layout 
              layout.on_notification do |notification|
                NSLog "Received notification of #{notification.name} on tables layout"
              end
            end   
            scroll.on_notification do |notification|
              NSLog "Received notification of #{notification.name} on scroll"
            end
         end    
               
          
          
        end 
        

        
      end                                        

      @window.on_notification :named => 'NSWindowDidResizeNotification' do |notification|
         NSLog "A window resized!"
      end

      5.times do
        on_button_click
      end
      
    end               
  
  end 
  
  def on_button_click    
    return unless @tables
    NSLog "pero" 
    @tables <<  draw_table    
  end                     
  
  
  # file/open
  def on_open(menu)
  end
  
  # file/new 
  def on_new(menu)
  end
  
  # help menu item
  def on_help(menu)
  end
  
  # This is commented out, so the minimize menu item is disabled
  #def on_minimize(menu)
  #end
  
  # window/zoom
  def on_zoom(menu)
  end
  
  # window/bring_all_to_front
  def on_bring_all_to_front(menu)
  end
end

Application.new.start