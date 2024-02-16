As hint suggests we call select on tasks but tasks is nil..
I fixed it with this:
def display_high_priority_tasks
    tasks = self.tasks.select do |task|
      task.priority == :high
    end

which makes me suspect `tasks` somehow references a local variable tasks and not the instance gett
tasks. I think the order of referencing starts at local var then instance getter method.
so when we do tasks =, we are initializing a lcoal var called `tasks` that gets prioritized over
the getter

Ans key:
Next, Ruby must disambiguate the reference to tasks on the right-hand side of the assignment operator, seen in the code tasks.select. At this point, the getter method tasks is shadowed by the local variable that was just initialized on the left side of the assignment operator. You can see this shadowing at work also in the private display method, where tasks in the method body refers to the method parameter, not the getter method.

ah true...
def display(tasks)
    puts "--------"
    tasks.each do |task|
      puts task
    end
    puts "--------"
  end

class TaskManager
  attr_reader :owner
  attr_accessor :tasks

  def initialize(owner)
    @owner = owner
    @tasks = []
  end

  def add_task(name, priority=:normal)
    task = Task.new(name, priority)
    tasks.push(task)
  end

  def complete_task(task_name)
    completed_task = nil

    tasks.each do |task|
      completed_task = task if task.name == task_name
    end

    if completed_task
      tasks.delete(completed_task)
      puts "Task '#{completed_task.name}' complete! Removed from list."
    else
      puts "Task not found."
    end
  end

  def display_all_tasks
    display(tasks)
  end

  def display_high_priority_tasks
    tasks = self.tasks.select do |task|
      task.priority == :high
    end

    display(tasks)
  end

  private

  def display(tasks)
    puts "--------"
    tasks.each do |task|
      puts task
    end
    puts "--------"
  end
end

class Task
  attr_accessor :name, :priority

  def initialize(name, priority=:normal)
    @name = name
    @priority = priority
  end

  def to_s
    "[" + sprintf("%-6s", priority) + "] #{name}"
  end
end

valentinas_tasks = TaskManager.new('Valentina')

valentinas_tasks.add_task('pay bills', :high)
valentinas_tasks.add_task('read OOP book')
valentinas_tasks.add_task('practice Ruby')
valentinas_tasks.add_task('run 5k', :low)

valentinas_tasks.complete_task('read OOP book')

valentinas_tasks.display_all_tasks
valentinas_tasks.display_high_priority_tasks