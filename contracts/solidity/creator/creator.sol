
contract creator {
    other o;

    function create_child(uint128 deposit) public {
        o = new other{value: deposit}();
    }

    function balance() public view returns (uint128) {
        return address(this).balance;
    }

    function child_balance() public returns (uint128 v) {
        return o.balance();
    }

    function child_send(uint128 v) public {
        payable(o).send(v);
    }

    function child_get_val() public returns (uint64) {
        return o.get_val();
    }

    function child_set_val(uint64 v, uint128 value) public {
        o.set_val{value: value}(v);
    }
}

contract other {
    uint32 receives;
    uint64 val;

    receive() payable external {
        receives += 1;
    }

    function set_val(uint64 v) payable public {
        val = v;
    }

    function get_val() view public returns (uint64) {
        return val;
    }

    function balance() public view returns (uint128) {
        return address(this).balance;
    }
}