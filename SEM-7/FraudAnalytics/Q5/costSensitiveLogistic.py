"""
To run: python3 costSensitiveLogistic.py
"""

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from torch.utils.data import DataLoader, TensorDataset, random_split

torch.manual_seed(0)
torch.backends.cudnn.deterministic = True
torch.backends.cudnn.benchmark = False
np.random.seed(0)

# Global variables
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
PATH = "./data.csv"
fpc, tpc, tnc = 150.0, 150.0, 0.0
fnc = None
cols = None

__AUTHORS__ = [
    ("Vinta Reethu", "ES18BTECH11028"),
    ("Akash Tadwai", "ES18BTECH11019"),
    ("Chaitanya Janakie", "CS18BTECH11036"),
]


class Net(nn.Module):
    def __init__(self, in_dim, out_dim):
        super(Net, self).__init__()
        self.linear = nn.Sequential(nn.Linear(in_dim, out_dim), nn.Sigmoid())

    def forward(self, x):
        return self.linear(x)


def preProcesData():
    """Loads data and divides it into train and test sets."""
    global fnc, cols
    df = pd.read_csv(PATH)
    # defining all costs
    fnc = df.iloc[:, -1]  # last column is false negative costs

    # convert data to Pytorch Tensors
    df = df.drop(["FNC"], axis=1)  # drop the last column (FNC)
    data, targets = df.iloc[:, 1:], df.iloc[:, 0]
    cols = df.columns.shape[0] - 1  # X shape
    data, targets, fnc = (
        torch.FloatTensor(data.to_numpy()),
        torch.LongTensor(targets.to_numpy()),
        torch.FloatTensor(fnc.to_numpy()),
    )

    # Split into train, validation and test data
    dataset = TensorDataset(data, targets, fnc)
    trainset, valset, testset = random_split(dataset, [100000, 15000, 32636])
    trainloader = DataLoader(trainset, batch_size=1024, shuffle=True)
    valloader = DataLoader(valset, batch_size=1024, shuffle=False)
    testloader = DataLoader(testset, batch_size=1024, shuffle=False)

    # return trainloader, valloader, testloader
    return trainloader, valloader, testloader


def train(model, device, train_loader, optimizer, epoch):
    """Trains the model for one epoch"""
    model.train()
    correct, total = 0, 0
    loss_epoch = []  # to plot loss
    for _, (data, target, cfn) in enumerate(train_loader):
        # send the image, target to the device
        data, target, cfn = data.to(device), target.to(device), cfn.to(device)
        # flush out the gradients stored in optimizer
        optimizer.zero_grad()
        # pass the image to the model and assign the output to variable named output
        hx = model(data).squeeze(1)
        # calculate the loss using the output and the target
        pred = (hx > 0.5).long()
        correct += (pred == target).sum().item()
        total += hx.size(0)

        loss = target * (hx * tpc + (1 - hx) * cfn) + (1 - target) * (
            hx * fpc + (1 - hx) * tnc
        )  # calculate cost sensitive Loss
        loss = loss.mean()

        loss.backward()  # calculate gradients of all parameters with respect to the loss
        loss_epoch.append(loss.data.item())
        optimizer.step()

    return np.mean(loss_epoch), 100.0 * correct / total, model


def validation(model, device, val_loader):
    model.eval()
    correct, total = 0, 0
    losses = []
    with torch.no_grad():
        for data, target, cfn in val_loader:
            data, target, cfn = data.to(device), target.to(device), cfn.to(device)
            hx = model(data).squeeze(1)
            pred = (hx > 0.5).long()
            correct += (pred == target).sum().item()
            total += hx.size(0)
            loss = target * (hx * tpc + (1 - hx) * cfn) + (1 - target) * (
                hx * fpc + (1 - hx) * tnc
            )
            losses.append(loss.mean().item())

    return np.mean(losses), 100.0 * correct / total, model


def test(model, device, test_loader):
    model.eval()
    model.load_state_dict(torch.load("./best.pth"))
    correct, total = 0, 0
    tp, fp, fn = 0, 0, 0
    for (x, y, cfn) in test_loader:  # evaluate on test data
        x, y, cfn = x.to(device), y.to(device), cfn.to(device)
        hx = model(x).squeeze(1)
        # for accuracy, find correct predictions
        pred = (hx > 0.5).long()
        correct += (pred == y).sum().item()
        total += hx.size(0)

        # find true positives, false positives, false negatives
        tp += ((pred == 1) * (y == 1)).sum().item()
        fp += ((pred == 1) * (y == 0)).sum().item()
        fn += ((pred == 0) * (y == 1)).sum().item()

    # Find accuracy, precision, recall, F1 Score
    prec, rec = 1.0 * tp / (tp + fp), 1.0 * tp / (tp + fn)
    f1 = 2 * prec * rec / (prec + rec)

    print(
        "\nTest accuracy {:.3f}, Precision {:.3f}, Recall {:.3f}, F1 {:.3f}".format(
            100.0 * correct / total, prec, rec, f1
        )
    )


def plotting(
    epochs, train_loss_values, train_acc_values, test_loss_values, test_acc_values
) -> None:
    plt.plot(epochs, train_loss_values, "r-", label="Train", marker="x")
    plt.plot(epochs, test_loss_values, "b-", label="Validation", marker="o")
    plt.xlabel("Epochs")
    plt.ylabel("Loss")
    plt.title("Loss Graph")
    plt.legend()
    plt.savefig("./Loss.png")
    plt.show()
    print("")
    plt.xlabel("Epochs")
    plt.ylabel("Accuracy")
    plt.title("Accuracy Graph")
    plt.plot(epochs, train_acc_values, "r-", label="Train Acc", marker="x")
    plt.plot(epochs, test_acc_values, "b-", label="Validation Acc", marker="o")
    plt.legend()
    plt.savefig("./Accuracy.png")
    plt.show()


if __name__ == "__main__":

    trainloader, valloader, testloader = preProcesData()

    model = Net(cols, 1).to(device)
    optimizer = torch.optim.Adam(model.parameters())

    train_loss_values = []
    train_acc_values = []
    val_loss_values = []
    val_acc_values = []
    EPOCHS = 20  # number of epochs
    best_acc = 0.0

    for epoch in range(1, EPOCHS + 1):
        train_loss, train_acc, model = train(
            model, device, trainloader, optimizer, epoch
        )
        val_loss, val_acc, model = validation(model, device, valloader)
        train_loss_values.append(train_loss)
        train_acc_values.append(train_acc)
        val_loss_values.append(val_loss)
        val_acc_values.append(val_acc)

        if val_acc_values[-1] > best_acc:  # if val acc is better, save checkpoint
            torch.save(model.state_dict(), "./best.pth")
            best_acc = val_acc_values[-1]
        print(
            f"Epoch: {epoch} TrainLoss: {train_loss_values[-1]:.3f}    ValLoss: {val_loss_values[-1]:.3f}    TrainAccuracy: {train_acc_values[-1]:.3f}    ValAccuracy: {val_acc_values[-1]:.3f}"
        )

    plotting(
        np.linspace(1, EPOCHS, EPOCHS).astype(int),
        train_loss_values,
        train_acc_values,
        val_loss_values,
        val_acc_values,
    )
    test(model, device, testloader)
