/* Singleton
 * @class Tasks
 * @static
 ***************/
import CleanLibTask from './tasks/CleanLibTask';

class Tasks {
	private static instance: Tasks;
	CleanLibTask = CleanLibTask;

	protected constructor() {}

	static getInstance() {
		if (this.instance) return this.instance;
		return this.instance = new Tasks()
	}

}

export default Tasks.getInstance()