public virtual class TriggerHandler {

    public void run(){

        if(!Trigger.isExecuting){
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }

        if(Trigger.isBefore && Trigger.isInsert){
            this.beforeInsert();
        }else if(Trigger.isBefore && Trigger.isUpdate){
            this.beforeUpdate();
        }else if(Trigger.isBefore && Trigger.isDelete){
            this.beforeDelete();
        }else if(Trigger.isAfter && Trigger.isInsert){
            this.afterInsert();
        }else if(Trigger.isAfter && Trigger.isUpdate){
            this.afterUpdate();
        }else if(Trigger.isAfter && Trigger.isDelete){
            this.afterDelete();
        }else if(Trigger.isAfter && Trigger.isUndelete){
            this.afterUndelete();
        }

    }

    public virtual void beforeInsert(){}
    public virtual void beforeUpdate(){}
    public virtual void beforeDelete(){}
    public virtual void afterInsert(){}
    public virtual void afterUpdate(){}
    public virtual void afterDelete(){}
    public virtual void afterUndelete(){}

    public class TriggerHandlerException extends Exception{}
}