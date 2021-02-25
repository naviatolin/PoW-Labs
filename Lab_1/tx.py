# %%
import matplotlib.pyplot as plt
import numpy as np

#%%
class QAM:
    def transmit(self):
        # 1000 bits per second
        # 1 bit = 1/2 pair, 1 pair = 2 bit
        # 1000 bits = 500 pairs
        # we need 500 pairs per second
        # 
        # currently sampling output at 2e6
        # 1000 bits * 50 width = 50,000 samples
        #
        # for 1kib @ 50 width, sample at 50,000/sec (5e4)

    
        data_length = 1000 # bits
        sync_length = 50 # bits / 2
        symbol_period = 50 # samples
        pad_length = 10000 # samples

        i, q = self.create_data(data_length/2)
        
        # add headers to the data
        i = self.add_sync(data = i, sync_length = sync_length)
        q = self.add_sync(data = q, sync_length = sync_length)

        data = self.combine_RI(i, q)
        data = self.space_out(data, symbol_period = symbol_period)
        data = self.pad_data(data, pad_length= pad_length)

        # Spread the data by symbol period
        final_data = self.place_out_of_phase(data)

        write_data_to_file(final_data, "tx_daaaata.dat")
        return final_data

    def create_data(self, length):
        """
            Create a string of 1's and -1's.
        """
        i = np.random.randint(2 ,size=length) * 2 - 1
        q = np.random.randint(2 ,size=length) * 2 - 1
        return i, q

    def add_sync(self, data, sync_length):
        """
            Add a sync section at the beginning of the message.
        """
        sync = np.repeat([1, 1], sync_length/2)
        return np.concatenate((sync, data))
        
    def combine_RI(self, i, q):
        """
            Combine the real and imaginary portions.
        """
        # co = real + 1j * imaginary
        return i + 1j * q

    def space_out(self, data, symbol_period):
        """
            Set data up with symbol period.
        """
        new_data = np.repeat(data, symbol_period)
        return new_data

    def pad_data(self, data, pad_length):
        """
            Pad the data with zeros to send it.
        """
        front_padding = np.repeat([0 + 0j], pad_length)
        back_padding = np.repeat([0 + 0j], pad_length)
        return np.concatenate((front_padding, data, back_padding))

    def place_out_of_phase(self, data):
        """
            Place the two messages out of phase with each other.
        """
        new_data = np.column_stack((np.real(data),np.imag(data))).flatten()
        return new_data

    def write_data_to_file(self, array, filename: str,):
        """
            Write data to a file.
        """
        array.astype('float32').tofile(filename)


    def receive(self):
        pass
    
    def plot_constellation(self):
        '''
        Plot a constellation diagram representing the modulation scheme.
        '''
        data = [(a*np.cos(p/180.0*np.pi), a*np.sin(p/180.0*np.pi), t) 
                for t,(a,p) in self.modulation.items()]
        sx,sy,t = zip(*data)
        plt.clf()
        plt.scatter(sx,sy,s=30)
        plt.axes().set_aspect('equal')
        for x,y,t in data:
            plt.annotate(t,(x-.03,y-.03), ha='right', va='top')
        plt.axis([-1.5,1.5,-1.5,1.5])
        plt.axhline(0, color='red')
        plt.axvline(0, color='red')
        plt.grid(True)

        


#%%
qam = QAM()
# %% TEST: Create Data
i, q = qam.create_data(20)

(i, q)
# %% TEST: Add sync
sync_data = qam.add_sync(i, 10)
plt.stem(sync_data)

#%% TEST: Combine RI,
combined = qam.combine_RI(i, q)
combined

# %% TEST: Test space out
qam.space_out(combined, 3)

# %%

qam.transmit()
# %%
loaded = np.fromfile("rx.dat", dtype="float32")

# %%
plt.stem(loaded)


# %%
