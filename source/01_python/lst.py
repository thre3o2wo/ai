def safe_index(lst, item):
    '''If the item is in the the lst, returns the index of item.
    If the item is not in the lst, returns -1.'''
    if item in lst:
        return lst.index(item)
    return -1