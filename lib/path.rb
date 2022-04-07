#!/usr/bin/env ruby
# Id$ nonnax 2022-03-30 19:16:14 +0800
module Path
  extend self
  def start(&block)
    @stack=[]
    @routes=[]
    @map=Hash.new{|h,k| h[k]=[]}
    instance_eval(&block)
  end

  attr :stack, :level, :map

  define_method(:on) do |v='GET',a, &block|
    a='' if stack.size.zero?
    stack.push a
    block.call(stack.dup)
    @routes.push stack.pop # unwinding
    if stack.size==1
      @map[v].push [stack.last, @routes.reverse].flatten.join('/')
      @routes=[]
    end
  end
  def get(a, &block)  on('GET', a, &block) end
  def post(a, &block) on('POST', a, &block) end
end


Path.start do
  on(1) do |a|
    on('b'){|b| p [a, b]}
  end
end

p Path.map

Path.start do
 on(2){ |a|
   get('next'){|b| 
      on('again'){|c| p [a, b, c]}
    }
   post('sib'){|b|  
      on('insan') do |c|
        on('2nd insan'){|d| p [a, b, c, d]}
      end      
    }

  post('last'){|b|
    on('end'){|c| p [b, c]}
  }
}
end

p Path.map
