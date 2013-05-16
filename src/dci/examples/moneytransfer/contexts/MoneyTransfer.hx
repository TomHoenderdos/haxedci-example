package dci.examples.moneytransfer.contexts;

// TODO: Auto-generate interfaces from Roles

typedef SourceAccountInterface = 
{
	function withdraw(amount : Float) : Void;
}

typedef DestinationAccountInterface = 
{
	function deposit(amount : Float) : Void;
}

typedef IAmount = Float;

class MoneyTransfer implements dci.Context
{
	@role var sourceAccount : SourceAccount;
	@role var destinationAccount : DestinationAccount;
	@role var amount : Amount;

	public function new(source : SourceAccountInterface, destination : DestinationAccountInterface, amount : IAmount)
	{
		bindRoles(source, destination, amount);
	}

	function bindRoles(source, destination, amt)
	{
		sourceAccount = new SourceAccount(source);
		destinationAccount = new DestinationAccount(destination);
		amount = new Amount(amt);
		
		// Object identity assertions
		if (untyped sourceAccount != source)
			throw "Object identity broken for sourceAccount";

		if (untyped destinationAccount != destination)
			throw "Object identity broken for sourceAccount";

		if (untyped amount != amt)
			throw "Object identity broken for amount";
	}
	
	// Interaction
	public function Execute()
	{
		sourceAccount.Transfer();
	}
}

@:build(Dci.role(MoneyTransfer))
private abstract Amount(Float) from Float to Float
{
	public inline function new(amount)
	{
		this = amount;
	}	
}

@:build(Dci.role(MoneyTransfer))
private abstract SourceAccount(SourceAccountInterface)
{
	public inline function new(account)
	{
		this = account;
	}
	
	public function Transfer()
	{
		// First one gets Autocomplete, second one and "context" doesn't?
		//var context2 : MoneyTransfer = dci.ContextStorage.current;
		//var context2 = cast(ContextStorage.current, MoneyTransfer);
		
		this.withdraw(context.amount);
		context.destinationAccount.deposit(context.amount);
	}
	
	public function withdraw(amount : Float)
	{
		this.withdraw(amount);
	}
}

@:build(Dci.role(MoneyTransfer))
private abstract DestinationAccount(DestinationAccountInterface)
{
	public inline function new(account)
	{
		this = account;
	}
	
	public function deposit(amount : Float)
	{
		this.deposit(amount);
	}
}